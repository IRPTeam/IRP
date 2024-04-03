#language: en
@tree
@Positive
@OpeningEntries

Feature: check opening entry

As a developer
I want to create a document to enter the opening balance
To input the client's balance when you start working with the base

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



# it's necessary to add tests to start the remainder of the documents
Scenario: _400000 preparation (Opening entries)
	When set True value to the constant
	When set True value to the constant Use salary 
	When set True value to the constant Use fixed assets
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Countries objects
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog BusinessUnits objects
		When Create OtherPartners objects
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
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog RetailCustomers objects (check POS)
		When Create information register Taxes records (VAT)
		When Create catalog EmployeePositions objects
		When Create catalog AccrualAndDeductionTypes objects
		When Create catalog EmployeeSchedule objects

	
Scenario: _4000001 check preparation
	When check preparation

Scenario: _400001 opening entry account balance
	* Open document form for opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
	* Filling in the tabular part account balance
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I click choice button of "Currency" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Code    |
			| TRY     |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "1 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description     |
			| Cash desk №2    |
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I click choice button of "Currency" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Code   | Description        |
			| USD    | American dollar    |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "1 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description     |
			| Cash desk №3    |
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I click choice button of "Currency" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Code   | Description    |
			| EUR    | Euro           |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "1 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description          |
			| Bank account, TRY    |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "10 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description          |
			| Bank account, USD    |
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "5 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description          |
			| Bank account, EUR    |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "8 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
	* Check filling in currency rate
		* Filling in currency rate Cash desk №3
			And I go to line in "AccountBalance" table
				| 'Account'         | 'Amount'      | 'Currency'     |
				| 'Cash desk №3'    | '1 000,00'    | 'EUR'          |
			And I activate "Account" field in "AccountBalance" table
			And in the table "AccountBalance" I click "Edit currencies account balance" button
			And I activate "Rate" field in "CurrenciesTable" table
			And I input "5,6883" text in "Rate" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And I go to line in "CurrenciesTable" table
				| 'From'    | 'Movement type'         | 'Multiplicity'    | 'To'     | 'Type'          |
				| 'EUR'     | 'Reporting currency'    | '1'               | 'USD'    | 'Reporting'     |
			And I select current line in "CurrenciesTable" table
			And I input "1,1000" text in "Rate" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And I click "Ok" button		
		* Filling in currency rate Bank account, EUR
			And I go to line in "AccountBalance" table
				| 'Account'              | 'Currency'     |
				| 'Bank account, EUR'    | 'EUR'          |
			And I activate "Account" field in "AccountBalance" table
			And in the table "AccountBalance" I click "Edit currencies account balance" button
			And I activate "Rate" field in "CurrenciesTable" table
			And I input "5,6883" text in "Rate" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And I go to line in "CurrenciesTable" table
				| 'From'    | 'Movement type'         | 'Multiplicity'    | 'To'     | 'Type'          |
				| 'EUR'     | 'Reporting currency'    | '1'               | 'USD'    | 'Reporting'     |
			And I select current line in "CurrenciesTable" table
			And I input "1,100000" text in "Rate" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And I click "Ok" button		
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry400001$$" variable
		And I delete "$$OpeningEntry400001$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry400001$$"
		And I save the window as "$$OpeningEntry400001$$"
		And I click the button named "FormPostAndClose"
		And Delay 5
	* Check creation
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberOpeningEntry400001$$'    |




Scenario: _400002 opening entry inventory balance
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
	* Filling in the tabular part Inventory
		And I move to "Inventory" tab
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | XS/Blue     |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description    |
			| Store 01       |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "500,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | S/Yellow    |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description    |
			| Store 02       |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "400,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | XS/Blue     |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description    |
			| Store 01       |
		And I select current line in "List" table
		And I finish line editing in "Inventory" table
		And I activate "Quantity" field in "Inventory" table
		And I select current line in "Inventory" table
		And I input "400,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item       | Item key     |
			| Trousers   | 38/Yellow    |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description    |
			| Store 02       |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item       | Item key     |
			| Trousers   | 38/Yellow    |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description    |
			| Store 01       |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Shirt   | 36/Red      |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description    |
			| Store 02       |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Shirt   | 36/Red      |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description    |
			| Store 01       |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Boots   | 36/18SD     |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description    |
			| Store 02       |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "200,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Boots   | 36/18SD     |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description    |
			| Store 01       |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "300,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | L/Green     |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "500,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | L/Green     |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description    |
			| Store 02       |
		And I select current line in "List" table
		And I finish line editing in "Inventory" table
		And I go to line in "Inventory" table
			| 'Item key'   | 'Quantity'   | 'Store'       |
			| 'L/Green'    | '500,000'    | 'Store 01'    |
		And I activate "Quantity" field in "Inventory" table
		And I go to line in "Inventory" table
			| Item key   | Store       |
			| L/Green    | Store 02    |
		And I select current line in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry400002$$" variable
		And I delete "$$OpeningEntry400002$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry400002$$"
		And I save the window as "$$OpeningEntry400002$$"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberOpeningEntry400002$$'    |
	

Scenario: _400003 opening entry advance balance
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry400003$$" variable
		And I delete "$$OpeningEntry400003$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry400003$$"
		And I save the window as "$$OpeningEntry400003$$"
	* Filling in AdvanceFromCustomers
		And in the table "AdvanceFromCustomers" I click the button named "AdvanceFromCustomersAdd"
		And I click choice button of the attribute named "AdvanceFromCustomersPartner" in "AdvanceFromCustomers" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I activate field named "AdvanceFromCustomersCurrency" in "AdvanceFromCustomers" table
		And I click choice button of the attribute named "AdvanceFromCustomersCurrency" in "AdvanceFromCustomers" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Code'   | 'Description'     |
			| 'TRY'    | 'Turkish lira'    |
		And I select current line in "List" table
		And I activate field named "AdvanceFromCustomersAmount" in "AdvanceFromCustomers" table
		And I input "100,00" text in the field named "AdvanceFromCustomersAmount" of "AdvanceFromCustomers" table
		And I finish line editing in "AdvanceFromCustomers" table
	* Filling in AdvanceToSuppliers
		And I move to "To suppliers" tab
		And in the table "AdvanceToSuppliers" I click the button named "AdvanceToSuppliersAdd"
		And I click choice button of the attribute named "AdvanceToSuppliersPartner" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I finish line editing in "AdvanceToSuppliers" table
		And I activate field named "AdvanceToSuppliersLegalName" in "AdvanceToSuppliers" table
		And I select current line in "AdvanceToSuppliers" table
		And I click choice button of the attribute named "AdvanceToSuppliersLegalName" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I activate field named "AdvanceToSuppliersCurrency" in "AdvanceToSuppliers" table
		And I click choice button of the attribute named "AdvanceToSuppliersCurrency" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Code'   | 'Description'     |
			| 'TRY'    | 'Turkish lira'    |
		And I select current line in "List" table
		And I activate field named "AdvanceToSuppliersAmount" in "AdvanceToSuppliers" table
		And I input "100,00" text in the field named "AdvanceToSuppliersAmount" of "AdvanceToSuppliers" table
		And I finish line editing in "AdvanceToSuppliers" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry400003$$" variable
		And I delete "$$OpeningEntry400003$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry400003$$"
		And I save the window as "$$OpeningEntry400003$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberOpeningEntry400003$$'    |
		And I close all client application windows


Scenario: _400004 opening entry Vendors transaction by partner terms (vendors)
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
	* Filling in Account payable
		* Filling in partner and Legal name
			And I move to "Account payable" tab
			And in the table "AccountPayableByAgreements" I click "Add" button
			And I click choice button of "Partner" attribute in "AccountPayableByAgreements" table
			And I go to line in "List" table
				| 'Description'     |
				| 'DFC'             |
			And I select current line in "List" table
			And I finish line editing in "AccountPayableByAgreements" table
		* Check filling in legal name
				And "AccountPayableByAgreements" table contains lines
				| 'Partner'    | 'Legal name'     |
				| 'DFC'        | 'DFC'            |
		* Create test partner term with AP/AR posting detail - By partner terms (type Vendor)
			And I click choice button of "Partner term" attribute in "AccountPayableByAgreements" table
			And I click the button named "FormCreate"
			And I expand "Agreement info" group
			And I expand "Price settings" group
			And I expand "Store and delivery" group
			And I change "AP/AR posting detail" radio button value to "By partner terms"
			And I change "Type" radio button value to "Vendor"
			And I input "DFC Vendor by Partner terms" text in the field named "Description_en"
			And I input "01.12.2019" text in "Date" field
			And I click Select button of "Multi currency movement type" field
			And I go to line in "List" table
				| 'Currency'    | 'Description'    | 'Source'          | 'Type'             |
				| 'TRY'         | 'TRY'            | 'Forex Seling'    | 'Partner term'     |
			And I select current line in "List" table
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| 'Currency'    | 'Description'          |
				| 'TRY'         | 'Vendor price, TRY'    |
			And I select current line in "List" table
			And I input "01.12.2019" text in "Start using" field
			And I click "Save and close" button
			And I go to line in "List" table
			| 'Description'                    |
			| 'DFC Vendor by Partner terms'    |
			And I click the button named "FormChoose"
		* Filling in amount and currency
			And I activate "Currency" field in "AccountPayableByAgreements" table
			And I select current line in "AccountPayableByAgreements" table
			And I click choice button of "Currency" attribute in "AccountPayableByAgreements" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| 'Code'    | 'Description'      |
				| 'TRY'     | 'Turkish lira'     |
			And I select current line in "List" table
			And I activate "Amount" field in "AccountPayableByAgreements" table
			And I input "100,00" text in "Amount" field of "AccountPayableByAgreements" table
			And I finish line editing in "AccountPayableByAgreements" table
		* Check calculation Reporting currency
			And in the table "AccountPayableByAgreements" I click "Edit currencies account payable by agreements" button
			And "CurrenciesTable" table became equal
				| 'Movement type'         | 'Type'            | 'To'     | 'From'    | 'Multiplicity'    | 'Rate'      | 'Amount'     |
				| 'Reporting currency'    | 'Reporting'       | 'USD'    | 'TRY'     | '1'               | '0,171200'    | '17,12'      |
				| 'Local currency'        | 'Legal'           | 'TRY'    | 'TRY'     | '1'               | '1'         | '100'        |
				| 'TRY'                   | 'Partner term'    | 'TRY'    | 'TRY'     | '1'               | '1'         | '100'        |
			And I click "Ok" button		
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry400004$$" variable
		And I delete "$$OpeningEntry400004$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry400004$$"
		And I save the window as "$$OpeningEntry400004$$"
		And I click the button named "FormPostAndClose"
		And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberOpeningEntry400004$$'    |
		And I close all client application windows

	
Scenario: _400005 opening entry Customers transactions by partner terms (customers)
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
	* Filling in Account receivable
		* Filling in partner and Legal name
			And I move to "Account receivable" tab
			And in the table "AccountReceivableByAgreements" I click "Add" button
			And I click choice button of "Partner" attribute in "AccountReceivableByAgreements" table
			And I go to line in "List" table
				| 'Description'     |
				| 'DFC'             |
			And I select current line in "List" table
			And I finish line editing in "AccountReceivableByAgreements" table
		* Check filling in legal name
				And "AccountReceivableByAgreements" table contains lines
				| 'Partner'    | 'Legal name'     |
				| 'DFC'        | 'DFC'            |
		* Create test partner term with AP/AR posting detail - By partner terms (type Customer)
			And I click choice button of "Partner term" attribute in "AccountReceivableByAgreements" table
			And I click the button named "FormCreate"
			And I expand "Agreement info" group
			And I expand "Price settings" group
			And I expand "Store and delivery" group
			And I change "AP/AR posting detail" radio button value to "By partner terms"
			And I change "Type" radio button value to "Customer"
			And I input "DFC Customer by Partner terms" text in the field named "Description_en"
			And I input "01.12.2019" text in "Date" field
			And I click Select button of "Multi currency movement type" field
			And I go to line in "List" table
				| 'Currency'    | 'Description'    | 'Source'          | 'Type'             |
				| 'TRY'         | 'TRY'            | 'Forex Seling'    | 'Partner term'     |
			And I select current line in "List" table
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I input "01.12.2019" text in "Start using" field
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description'                       |
				| 'DFC Customer by Partner terms'     |
			And I click the button named "FormChoose"
		* Filling in amount and currency
			And I activate "Currency" field in "AccountReceivableByAgreements" table
			And I select current line in "AccountReceivableByAgreements" table
			And I click choice button of "Currency" attribute in "AccountReceivableByAgreements" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| 'Code'    | 'Description'      |
				| 'TRY'     | 'Turkish lira'     |
			And I select current line in "List" table
			And I activate "Amount" field in "AccountReceivableByAgreements" table
			And I input "100,00" text in "Amount" field of "AccountReceivableByAgreements" table
			And I finish line editing in "AccountReceivableByAgreements" table
		* Check calculation Reporting currency
			And in the table "AccountReceivableByAgreements" I click "Edit currencies account receivable by agreements" button
			And "CurrenciesTable" table became equal
				| 'Movement type'         | 'Type'            | 'To'     | 'From'    | 'Multiplicity'    | 'Rate'      | 'Amount'     |
				| 'Reporting currency'    | 'Reporting'       | 'USD'    | 'TRY'     | '1'               | '0,171200'    | '17,12'      |
				| 'Local currency'        | 'Legal'           | 'TRY'    | 'TRY'     | '1'               | '1'         | '100'        |
				| 'TRY'                   | 'Partner term'    | 'TRY'    | 'TRY'     | '1'               | '1'         | '100'        |
			And I click "Ok" button	
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry400005$$" variable
		And I delete "$$OpeningEntry400005$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry400005$$"
		And I save the window as "$$OpeningEntry400005$$"
		And I click the button named "FormPostAndClose"
		And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberOpeningEntry400005$$'    |
		And I close all client application windows



Scenario: _400008 check the entry of the account balance, inventory balance, customers and vendors transactions, advance in one document
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
	* Filling in the tabular part Account Balance
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description     |
			| Cash desk №2    |
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I click choice button of "Currency" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Code   | Description        |
			| USD    | American dollar    |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "1 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
	* Filling in the tabular part Inventory
		And I move to "Inventory" tab
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | XS/Blue     |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description    |
			| Store 01       |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "10,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
	* Filling in Advance from Customers
		And in the table "AdvanceFromCustomers" I click the button named "AdvanceFromCustomersAdd"
		And I click choice button of the attribute named "AdvanceFromCustomersPartner" in "AdvanceFromCustomers" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I activate field named "AdvanceFromCustomersCurrency" in "AdvanceFromCustomers" table
		And I click choice button of the attribute named "AdvanceFromCustomersCurrency" in "AdvanceFromCustomers" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Code'   | 'Description'     |
			| 'TRY'    | 'Turkish lira'    |
		And I select current line in "List" table
		And I activate field named "AdvanceFromCustomersAmount" in "AdvanceFromCustomers" table
		And I input "525,00" text in the field named "AdvanceFromCustomersAmount" of "AdvanceFromCustomers" table
		And I finish line editing in "AdvanceFromCustomers" table
	* Filling in Advance to suppliers
		And I move to "To suppliers" tab
		And in the table "AdvanceToSuppliers" I click the button named "AdvanceToSuppliersAdd"
		And I click choice button of the attribute named "AdvanceToSuppliersPartner" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I finish line editing in "AdvanceToSuppliers" table
		And I activate field named "AdvanceToSuppliersLegalName" in "AdvanceToSuppliers" table
		And I select current line in "AdvanceToSuppliers" table
		And I click choice button of the attribute named "AdvanceToSuppliersLegalName" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I activate field named "AdvanceToSuppliersCurrency" in "AdvanceToSuppliers" table
		And I click choice button of the attribute named "AdvanceToSuppliersCurrency" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Code'   | 'Description'     |
			| 'TRY'    | 'Turkish lira'    |
		And I select current line in "List" table
		And I activate field named "AdvanceToSuppliersAmount" in "AdvanceToSuppliers" table
		And I input "811,00" text in the field named "AdvanceToSuppliersAmount" of "AdvanceToSuppliers" table
		And I finish line editing in "AdvanceToSuppliers" table
	* Filling in Account payable by agreements
		* Filling in partner and Legal name
			And I move to "Account payable" tab
			And in the table "AccountPayableByAgreements" I click "Add" button
			And I click choice button of "Partner" attribute in "AccountPayableByAgreements" table
			And I go to line in "List" table
				| 'Description'     |
				| 'DFC'             |
			And I select current line in "List" table
			And I finish line editing in "AccountPayableByAgreements" table
		* Check filling in legal name
				And "AccountPayableByAgreements" table contains lines
				| 'Partner'    | 'Legal name'     |
				| 'DFC'        | 'DFC'            |
		* Select partner term
			And I click choice button of "Partner term" attribute in "AccountPayableByAgreements" table
			And I go to line in "List" table
			| 'Description'                    |
			| 'DFC Vendor by Partner terms'    |
			And I click the button named "FormChoose"
		* Filling in amount and currency
			And I activate "Currency" field in "AccountPayableByAgreements" table
			And I select current line in "AccountPayableByAgreements" table
			And I click choice button of "Currency" attribute in "AccountPayableByAgreements" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| 'Code'    | 'Description'      |
				| 'TRY'     | 'Turkish lira'     |
			And I select current line in "List" table
			And I activate "Amount" field in "AccountPayableByAgreements" table
			And I input "111,00" text in "Amount" field of "AccountPayableByAgreements" table
			And I finish line editing in "AccountPayableByAgreements" table
	* Filling in Account receivable by agreements
		* Filling in partner and Legal name
			And I move to "Account receivable" tab
			And in the table "AccountReceivableByAgreements" I click "Add" button
			And I click choice button of "Partner" attribute in "AccountReceivableByAgreements" table
			And I go to line in "List" table
				| 'Description'     |
				| 'DFC'             |
			And I select current line in "List" table
			And I finish line editing in "AccountReceivableByAgreements" table
		* Check filling in legal name
				And "AccountReceivableByAgreements" table contains lines
				| 'Partner'    | 'Legal name'     |
				| 'DFC'        | 'DFC'            |
		* Select partner term
			And I click choice button of "Partner term" attribute in "AccountReceivableByAgreements" table
			And I go to line in "List" table
				| 'Description'                       |
				| 'DFC Customer by Partner terms'     |
			And I click the button named "FormChoose"
		* Filling in amount and currency
			And I activate "Currency" field in "AccountReceivableByAgreements" table
			And I select current line in "AccountReceivableByAgreements" table
			And I click choice button of "Currency" attribute in "AccountReceivableByAgreements" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| 'Code'    | 'Description'      |
				| 'TRY'     | 'Turkish lira'     |
			And I select current line in "List" table
			And I activate "Amount" field in "AccountReceivableByAgreements" table
			And I input "151,00" text in "Amount" field of "AccountReceivableByAgreements" table
			And I finish line editing in "AccountReceivableByAgreements" table
		* Check calculation Reporting currency
			And in the table "AccountReceivableByAgreements" I click "Edit currencies account receivable by agreements" button
			And "CurrenciesTable" table became equal
				| 'Movement type'         | 'Type'            | 'To'     | 'From'    | 'Multiplicity'    | 'Rate'      | 'Amount'     |
				| 'Reporting currency'    | 'Reporting'       | 'USD'    | 'TRY'     | '1'               | '0,171200'    | '25,85'      |
				| 'Local currency'        | 'Legal'           | 'TRY'    | 'TRY'     | '1'               | '1'         | '151'        |
				| 'TRY'                   | 'Partner term'    | 'TRY'    | 'TRY'     | '1'               | '1'         | '151'        |
			And I close current window			
			And I click the button named "FormPost"
			And I delete "$$NumberOpeningEntry400008$$" variable
			And I delete "$$OpeningEntry400008$$" variable
			And I save the value of "Number" field as "$$NumberOpeningEntry400008$$"
			And I save the window as "$$OpeningEntry400008$$"
		* Check creation
			Given I open hyperlink "e1cib/list/Document.OpeningEntry"
			And "List" table contains lines
				| 'Number'                           |
				| '$$NumberOpeningEntry400008$$'     |
			And I close all client application windows

		


Scenario: _400009 check the entry of the Vendors/Customers transactions by documents (with payment terms)
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Filling in AP by documents first string
		And I move to "Account payable" tab
		And I move to the tab named "GroupAccountPayableByDocuments"
		And in the table "AccountPayableByDocuments" I click the button named "AccountPayableByDocumentsAdd"
		And I click choice button of the attribute named "AccountPayableByDocumentsPartner" in "AccountPayableByDocuments" table
		And I go to line in "List" table
			| 'Description'    |
			| 'DFC'            |
		And I select current line in "List" table
		And I finish line editing in "AccountPayableByDocuments" table
		And I move to the next attribute
		And I activate field named "AccountPayableByDocumentsAgreement" in "AccountPayableByDocuments" table
		And I click choice button of the attribute named "AccountPayableByDocumentsAgreement" in "AccountPayableByDocuments" table
		And I go to line in "List" table
			| 'Description'                |
			| 'Partner term vendor DFC'    |
		And I select current line in "List" table
		And I select current line in "AccountPayableByDocuments" table
		And I activate field named "AccountPayableByDocumentsCurrency" in "AccountPayableByDocuments" table
		And I click choice button of the attribute named "AccountPayableByDocumentsCurrency" in "AccountPayableByDocuments" table
		And I go to line in "List" table
			| 'Code'   | 'Description'     |
			| 'TRY'    | 'Turkish lira'    |
		And I select current line in "List" table
		And I input "100,00" text in the field named "AccountPayableByDocumentsAmount" of "AccountPayableByDocuments" table
		And I finish line editing in "AccountPayableByDocuments" table
	* Filling in payment terms for first string
		And in the table "VendorsPaymentTerms" I click the button named "VendorsPaymentTermsAdd"
		And I activate field named "VendorsPaymentTermsCalculationType" in "VendorsPaymentTerms" table
		And I select current line in "VendorsPaymentTerms" table
		And I select "Post-shipment credit" exact value from the drop-down list named "VendorsPaymentTermsCalculationType" in "VendorsPaymentTerms" table
		And I activate field named "VendorsPaymentTermsDate" in "VendorsPaymentTerms" table
		And I input "30.12.2022" text in the field named "VendorsPaymentTermsDate" of "VendorsPaymentTerms" table
		And I activate field named "VendorsPaymentTermsAmount" in "VendorsPaymentTerms" table
		And I input "100,00" text in the field named "VendorsPaymentTermsAmount" of "VendorsPaymentTerms" table
	* Filling in AP by documents second string
		And in the table "AccountPayableByDocuments" I click the button named "AccountPayableByDocumentsAdd"
		And I activate field named "AccountPayableByDocumentsPartner" in "AccountPayableByDocuments" table
		And I click choice button of the attribute named "AccountPayableByDocumentsPartner" in "AccountPayableByDocuments" table
		Then "Partners" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'DFC'            |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I finish line editing in "AccountPayableByDocuments" table
		And I activate field named "AccountPayableByDocumentsAgreement" in "AccountPayableByDocuments" table
		And I select current line in "AccountPayableByDocuments" table
		And I click choice button of the attribute named "AccountPayableByDocumentsAgreement" in "AccountPayableByDocuments" table
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I activate field named "AccountPayableByDocumentsCurrency" in "AccountPayableByDocuments" table
		And I click choice button of the attribute named "AccountPayableByDocumentsCurrency" in "AccountPayableByDocuments" table
		Then "Currencies" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Euro'           |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I activate field named "AccountPayableByDocumentsAmount" in "AccountPayableByDocuments" table
		And I input "200,00" text in the field named "AccountPayableByDocumentsAmount" of "AccountPayableByDocuments" table
		And I finish line editing in "AccountPayableByDocuments" table
		And in the table "VendorsPaymentTerms" I click the button named "VendorsPaymentTermsAdd"
		And I go to the last line in "VendorsPaymentTerms" table
		And I activate field named "VendorsPaymentTermsCalculationType" in "VendorsPaymentTerms" table
		And I select current line in "VendorsPaymentTerms" table
		And I select "Post-shipment credit" exact value from the drop-down list named "VendorsPaymentTermsCalculationType" in "VendorsPaymentTerms" table
		And I activate field named "VendorsPaymentTermsDate" in "VendorsPaymentTerms" table
		And I input "30.12.2021" text in the field named "VendorsPaymentTermsDate" of "VendorsPaymentTerms" table
		And I activate field named "VendorsPaymentTermsAmount" in "VendorsPaymentTerms" table
		And I input "200,00" text in the field named "VendorsPaymentTermsAmount" of "VendorsPaymentTerms" table
		And I finish line editing in "VendorsPaymentTerms" table
	* Check filling in
		And I click "Show row key" button	
		And I go to line in "AccountPayableByDocuments" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "AccountPayableByDocuments" table
		And I delete "$$Rov1OpeningEntry400009$$" variable
		And I save the current field value as "$$Rov1OpeningEntry400009$$"
		And I go to line in "AccountPayableByDocuments" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "AccountPayableByDocuments" table
		And I delete "$$Rov2OpeningEntry400009$$" variable
		And I save the current field value as "$$Rov2OpeningEntry400009$$"
		And "AccountPayableByDocuments" table contains lines
			| 'Key'                          | '#'   | 'Partner'   | 'Amount'   | 'Legal name'   | 'Partner term'              | 'Currency'    |
			| '$$Rov1OpeningEntry400009$$'   | '1'   | 'DFC'       | '100,00'   | 'DFC'          | 'Partner term vendor DFC'   | 'TRY'         |
			| '$$Rov2OpeningEntry400009$$'   | '2'   | 'DFC'       | '200,00'   | 'DFC'          | 'Partner term vendor DFC'   | 'EUR'         |
		And "VendorsPaymentTerms" table contains lines
			| 'Key'                          | 'Calculation type'       | 'Date'         | 'Amount'    |
			| '$$Rov1OpeningEntry400009$$'   | 'Post-shipment credit'   | '30.12.2022'   | '100,00'    |
			| '$$Rov2OpeningEntry400009$$'   | 'Post-shipment credit'   | '30.12.2021'   | '200,00'    |
	* Filling in AR by documents first string
		And I move to "Account receivable" tab
		And I move to the tab named "GroupAccountReceivableByDocuments"
		And in the table "AccountReceivableByDocuments" I click the button named "AccountReceivableByDocumentsAdd"
		And I click choice button of the attribute named "AccountReceivableByDocumentsPartner" in "AccountReceivableByDocuments" table
		And I go to line in "List" table
			| 'Description'    |
			| 'DFC'            |
		And I select current line in "List" table
		And I move to the next attribute
		And I activate field named "AccountReceivableByDocumentsAgreement" in "AccountReceivableByDocuments" table
		And I click choice button of the attribute named "AccountReceivableByDocumentsAgreement" in "AccountReceivableByDocuments" table
		And I go to line in "List" table
			| 'Description'         |
			| 'Partner term DFC'    |
		And I select current line in "List" table
		And I activate field named "AccountReceivableByDocumentsCurrency" in "AccountReceivableByDocuments" table
		And I click choice button of the attribute named "AccountReceivableByDocumentsCurrency" in "AccountReceivableByDocuments" table
		And I go to line in "List" table
			| 'Code'   | 'Description'     |
			| 'TRY'    | 'Turkish lira'    |
		And I select current line in "List" table
		And I input "200,00" text in the field named "AccountReceivableByDocumentsAmount" of "AccountReceivableByDocuments" table
		And I finish line editing in "AccountReceivableByDocuments" table
	* Filling in payment terms for first string
		And in the table "CustomersPaymentTerms" I click the button named "CustomersPaymentTermsAdd"
		And I activate field named "CustomersPaymentTermsCalculationType" in "CustomersPaymentTerms" table
		And I select current line in "CustomersPaymentTerms" table
		And I select "Post-shipment credit" exact value from the drop-down list named "CustomersPaymentTermsCalculationType" in "CustomersPaymentTerms" table
		And I activate field named "CustomersPaymentTermsDate" in "CustomersPaymentTerms" table
		And I input "31.12.2022" text in the field named "CustomersPaymentTermsDate" of "CustomersPaymentTerms" table
		And I activate field named "CustomersPaymentTermsAmount" in "CustomersPaymentTerms" table
		And I input "200,00" text in the field named "CustomersPaymentTermsAmount" of "CustomersPaymentTerms" table
		And I finish line editing in "CustomersPaymentTerms" table
	* Filling in AR by documents second string
		And in the table "AccountReceivableByDocuments" I click the button named "AccountReceivableByDocumentsAdd"
		And I activate field named "AccountReceivableByDocumentsPartner" in "AccountReceivableByDocuments" table
		And I click choice button of the attribute named "AccountReceivableByDocumentsPartner" in "AccountReceivableByDocuments" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Lomaniti'       |
		And I select current line in "List" table
		And I finish line editing in "AccountReceivableByDocuments" table
		And I activate field named "AccountReceivableByDocumentsAgreement" in "AccountReceivableByDocuments" table
		And I select current line in "AccountReceivableByDocuments" table
		And I click choice button of the attribute named "AccountReceivableByDocumentsAgreement" in "AccountReceivableByDocuments" table
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I activate field named "AccountReceivableByDocumentsCurrency" in "AccountReceivableByDocuments" table
		And I click choice button of the attribute named "AccountReceivableByDocumentsCurrency" in "AccountReceivableByDocuments" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I activate field named "AccountReceivableByDocumentsAmount" in "AccountReceivableByDocuments" table
		And I input "100,00" text in the field named "AccountReceivableByDocumentsAmount" of "AccountReceivableByDocuments" table
		And I finish line editing in "AccountReceivableByDocuments" table
	* Filling in payment terms for second string
		And in the table "CustomersPaymentTerms" I click the button named "CustomersPaymentTermsAdd"
		And I go to the last line in "CustomersPaymentTerms" table
		And I activate field named "CustomersPaymentTermsCalculationType" in "CustomersPaymentTerms" table
		And I select current line in "CustomersPaymentTerms" table
		And I select "Post-shipment credit" exact value from the drop-down list named "CustomersPaymentTermsCalculationType" in "CustomersPaymentTerms" table
		And I activate field named "CustomersPaymentTermsDate" in "CustomersPaymentTerms" table
		And I input "21.12.2021" text in the field named "CustomersPaymentTermsDate" of "CustomersPaymentTerms" table
		And I activate field named "CustomersPaymentTermsAmount" in "CustomersPaymentTerms" table
		And I input "100,00" text in the field named "CustomersPaymentTermsAmount" of "CustomersPaymentTerms" table
		And I finish line editing in "CustomersPaymentTerms" table
	* Check filling in
		And I go to line in "AccountReceivableByDocuments" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "AccountReceivableByDocuments" table
		And I delete "$$Rov3OpeningEntry400009$$" variable
		And I save the current field value as "$$Rov3OpeningEntry400009$$"
		And I go to line in "AccountReceivableByDocuments" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "AccountReceivableByDocuments" table
		And I delete "$$Rov4OpeningEntry400009$$" variable
		And I save the current field value as "$$Rov4OpeningEntry400009$$"
		And "AccountReceivableByDocuments" table contains lines
			| 'Key'                          | '#'   | 'Partner'    | 'Amount'   | 'Legal name'         | 'Partner term'               | 'Currency'    |
			| '$$Rov3OpeningEntry400009$$'   | '1'   | 'DFC'        | '200,00'   | 'DFC'                | 'Partner term DFC'           | 'TRY'         |
			| '$$Rov4OpeningEntry400009$$'   | '2'   | 'Lomaniti'   | '100,00'   | 'Company Lomaniti'   | 'Basic Partner terms, TRY'   | 'TRY'         |
		And "CustomersPaymentTerms" table contains lines
			| 'Key'                          | 'Calculation type'       | 'Date'         | 'Amount'    |
			| '$$Rov3OpeningEntry400009$$'   | 'Post-shipment credit'   | '31.12.2022'   | '200,00'    |
			| '$$Rov4OpeningEntry400009$$'   | 'Post-shipment credit'   | '21.12.2021'   | '100,00'    |
	* Post 
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry400009$$" variable
		And I delete "$$OpeningEntry400009$$" variable
		And I delete "$$DateOpeningEntry400009$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry400009$$"
		And I save the value of the field named "Date" as "$$DateOpeningEntry400009$$"
		And I save the window as "$$OpeningEntry400009$$"
	* Check clearing of payment conditions when deleting a line (CustomersPaymentTerms)
		And I go to line in "AccountReceivableByDocuments" table
			| '#'   | 'Amount'   | 'Currency'   | 'Key'                          | 'Legal name'         | 'Partner'    | 'Partner term'                |
			| '2'   | '100,00'   | 'TRY'        | '$$Rov4OpeningEntry400009$$'   | 'Company Lomaniti'   | 'Lomaniti'   | 'Basic Partner terms, TRY'    |
		And I delete a line in "AccountReceivableByDocuments" table
		And "CustomersPaymentTerms" table does not contain lines
			| 'Key'                          | 'Calculation type'       | 'Date'         | 'Amount'    |
			| '$$Rov4OpeningEntry400009$$'   | 'Post-shipment credit'   | '21.12.2021'   | '100,00'    |
	* Check clearing of payment conditions when deleting a line (VendorsPaymentTerms)
		And I move to "Account payable" tab
		And I go to line in "AccountPayableByDocuments" table
			| '#'   | 'Amount'   | 'Currency'   | 'Key'                          | 'Legal name'   | 'Partner'   | 'Partner term'               |
			| '1'   | '100,00'   | 'TRY'        | '$$Rov1OpeningEntry400009$$'   | 'DFC'          | 'DFC'       | 'Partner term vendor DFC'    |
		And I delete a line in "AccountPayableByDocuments" table
		And "VendorsPaymentTerms" table does not contain lines
			| 'Key'                          | 'Calculation type'       | 'Date'         | 'Amount'    |
			| '$$Rov1OpeningEntry400009$$'   | 'Post-shipment credit'   | '30.12.2022'   | '100,00'    |
		And I click the button named "FormPostAndClose"		
	* Check creation
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberOpeningEntry400009$$'    |
		And I close all client application windows

Scenario: _400010 check filling price and sum in the OpeningEntry
		And I close all client application windows
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
	* Amount calculation
		And I move to "Inventory" tab
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | XS/Blue     |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description    |
			| Store 01       |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "500,000" text in "Quantity" field of "Inventory" table
		And I activate "Price" field in "Inventory" table
		And I input "10,00" text in "Price" field of "Inventory" table
		And I finish line editing in "Inventory" table
	* Check amount calculation
		And "Inventory" table became equal
			| 'Amount'     | 'Item'    | 'Item key'   | 'Store'      | 'Quantity'   | 'Price'   | 'Amount tax'    |
			| '5 000,00'   | 'Dress'   | 'XS/Blue'    | 'Store 01'   | '500,000'    | '10,00'   | ''              |
	* Price calculation	
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | S/Yellow    |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description    |
			| Store 02       |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "400,000" text in "Quantity" field of "Inventory" table
		And I activate field named "InventoryAmount" in "Inventory" table
		And I input "4 400,00" text in the field named "InventoryAmount" of "Inventory" table
		And I finish line editing in "Inventory" table
	* Check price calculation
		And "Inventory" table contains lines
			| 'Amount'     | 'Item'    | 'Item key'   | 'Store'      | 'Quantity'   | 'Price'    |
			| '4 400,00'   | 'Dress'   | 'S/Yellow'   | 'Store 02'   | '400,000'    | '11,00'    |
	* Change quantity and check amount
		And I go to line in "Inventory" table
			| '#'   | 'Amount'     | 'Item'    | 'Item key'   | 'Price'   | 'Quantity'   | 'Store'       |
			| '1'   | '5 000,00'   | 'Dress'   | 'XS/Blue'    | '10,00'   | '500,000'    | 'Store 01'    |
		And I select current line in "Inventory" table
		And I input "550,00" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And "Inventory" table contains lines
			| 'Amount'     | 'Item'    | 'Item key'   | 'Store'      | 'Quantity'   | 'Price'   | 'Amount tax'    |
			| '5 500,00'   | 'Dress'   | 'XS/Blue'    | 'Store 01'   | '550,000'    | '10,00'   | ''              |
	* Change amount and check price
		And I go to line in "Inventory" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'XS/Blue'     |
		And I select current line in "Inventory" table
		And I input "10 000,00" text in the field named "InventoryAmount" of "Inventory" table
		And I finish line editing in "Inventory" table
		And "Inventory" table contains lines
			| 'Amount'      | 'Item'    | 'Item key'   | 'Store'      | 'Quantity'   | 'Price'   | 'Amount tax'    |
			| '10 000,00'   | 'Dress'   | 'XS/Blue'    | 'Store 01'   | '550,000'    | '18,18'   | ''              |
	* Change price and check amount	
		And I go to line in "Inventory" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'XS/Blue'     |
		And I select current line in "Inventory" table
		And I input "22,00" text in "Price" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And "Inventory" table contains lines
			| 'Amount'      | 'Item'    | 'Item key'   | 'Store'      | 'Quantity'   | 'Price'   | 'Amount tax'    |
			| '12 100,00'   | 'Dress'   | 'XS/Blue'    | 'Store 01'   | '550,000'    | '22,00'   | ''              |
		And I close all client application windows


Scenario: _400012 create OpeningEntry (employee cash advance)
	And I close all client application windows
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
	* Filling Employee cash advance tab
		And I move to "Employee cash advance" tab
		* Add first line
			And in the table "EmployeeCashAdvance" I click "Add" button
			And I activate "Employee" field in "EmployeeCashAdvance" table
			And I select current line in "EmployeeCashAdvance" table
			And I click choice button of "Employee" attribute in "EmployeeCashAdvance" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Arina Brown'     |
			And I select current line in "List" table
			And I activate "Account" field in "EmployeeCashAdvance" table
			And I click choice button of "Account" attribute in "EmployeeCashAdvance" table
			And I go to line in "List" table
				| 'Currency'    | 'Description'           |
				| 'TRY'         | 'Bank account, TRY'     |
			And I select current line in "List" table
			And I activate "Financial movement type" field in "EmployeeCashAdvance" table
			And I click choice button of "Financial movement type" attribute in "EmployeeCashAdvance" table
			And I go to line in "List" table
				| 'Description'         |
				| 'Movement type 1'     |
			And I select current line in "List" table
			And I activate "Amount" field in "EmployeeCashAdvance" table
			And I input "1 000,00" text in "Amount" field of "EmployeeCashAdvance" table
			And I finish line editing in "EmployeeCashAdvance" table
		* Add second line
			And in the table "EmployeeCashAdvance" I click "Add" button
			And I activate "Employee" field in "EmployeeCashAdvance" table
			And I select current line in "EmployeeCashAdvance" table
			And I click choice button of "Employee" attribute in "EmployeeCashAdvance" table
			And I go to line in "List" table
				| 'Description'       |
				| 'David Romanov'     |
			And I select current line in "List" table
			And I activate "Account" field in "EmployeeCashAdvance" table
			And I click choice button of "Account" attribute in "EmployeeCashAdvance" table
			And I go to line in "List" table
				| 'Currency'    | 'Description'           |
				| 'USD'         | 'Bank account, USD'     |
			And I select current line in "List" table
			And I activate "Financial movement type" field in "EmployeeCashAdvance" table
			And I click choice button of "Financial movement type" attribute in "EmployeeCashAdvance" table
			And I go to line in "List" table
				| 'Description'         |
				| 'Movement type 1'     |
			And I select current line in "List" table
			And I activate "Amount" field in "EmployeeCashAdvance" table
			And I input "100,00" text in "Amount" field of "EmployeeCashAdvance" table
			And I finish line editing in "EmployeeCashAdvance" table
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry400012$$" variable
		And I delete "$$OpeningEntry400012$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry400012$$"
		And I save the window as "$$OpeningEntry400012$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberOpeningEntry400012$$'    |
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberOpeningEntry400012$$'    |
		And I select current line in "List" table
	* Check change sum
		And I go to line in "EmployeeCashAdvance" table
			| 'Amount'     | 'Currency'   | 'Employee'      | 'Financial movement type'    |
			| '1 000,00'   | 'TRY'        | 'Arina Brown'   | 'Movement type 1'            |
		And I select current line in "EmployeeCashAdvance" table
		And I input "1 200,00" text in "Amount" field of "EmployeeCashAdvance" table
		And I finish line editing in "EmployeeCashAdvance" table
		And I click "Save" button
		And "EmployeeCashAdvance" table contains lines
			| '#'   | 'Amount'     | 'Employee'        | 'Currency'   | 'Account'             | 'Financial movement type'    |
			| '1'   | '1 200,00'   | 'Arina Brown'     | 'TRY'        | 'Bank account, TRY'   | 'Movement type 1'            |
			| '2'   | '100,00'     | 'David Romanov'   | 'USD'        | 'Bank account, USD'   | 'Movement type 1'            |
		And I close all client application windows
				

Scenario: _400013 create OpeningEntry (salary payment)
	And I close all client application windows
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
	* Filling Salary payment
		And I move to "Salary payment" tab
		* Add first line
			And in the table "SalaryPayment" I click "Add" button
			And I activate "Employee" field in "SalaryPayment" table
			And I select current line in "SalaryPayment" table
			And I click choice button of "Employee" attribute in "SalaryPayment" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Arina Brown'     |
			And I select current line in "List" table
			And I activate "Currency" field in "SalaryPayment" table
			And I click choice button of "Currency" attribute in "SalaryPayment" table
			And I go to line in "List" table
				| 'Code'     |
				| 'TRY'      |
			And I select current line in "List" table
			And I activate "Amount" field in "SalaryPayment" table
			And I input "1 000,00" text in "Amount" field of "SalaryPayment" table
			And I finish line editing in "SalaryPayment" table
		* Add second line
			And in the table "SalaryPayment" I click "Add" button
			And I activate "Employee" field in "SalaryPayment" table
			And I select current line in "SalaryPayment" table
			And I click choice button of "Employee" attribute in "SalaryPayment" table
			And I go to line in "List" table
				| 'Description'       |
				| 'David Romanov'     |
			And I select current line in "List" table
			And I activate "Currency" field in "SalaryPayment" table
			And I click choice button of "Currency" attribute in "SalaryPayment" table
			And I go to line in "List" table
				| 'Code'     |
				| 'TRY'      |
			And I select current line in "List" table
			And I activate "Amount" field in "SalaryPayment" table
			And I input "2 000,00" text in "Amount" field of "SalaryPayment" table
			And I finish line editing in "SalaryPayment" table
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry400013$$" variable
		And I delete "$$OpeningEntry400013$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry400013$$"
		And I save the window as "$$OpeningEntry400013$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberOpeningEntry400013$$'    |
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberOpeningEntry400013$$'    |
		And I select current line in "List" table
	* Check change sum
		And I go to line in "SalaryPayment" table
			| 'Amount'     | 'Currency'   | 'Employee'       |
			| '1 000,00'   | 'TRY'        | 'Arina Brown'    |
		And I select current line in "SalaryPayment" table
		And I input "1 200,00" text in "Amount" field of "SalaryPayment" table
		And I finish line editing in "SalaryPayment" table
		And I click "Save" button
		And "SalaryPayment" table contains lines
			| '#'   | 'Amount'     | 'Employee'        | 'Currency'    |
			| '1'   | '1 200,00'   | 'Arina Brown'     | 'TRY'         |
			| '2'   | '2 000,00'   | 'David Romanov'   | 'TRY'         |
		And I close all client application windows
			

Scenario: _400014 create OpeningEntry (advance from retail customer)
	And I close all client application windows
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
	* Filling advance from retail customer
		And I move to "Advance from retail customers" tab
		* Add first line
			And in the table "AdvanceFromRetailCustomers" I click "Add" button
			And I activate "Retail customer" field in "AdvanceFromRetailCustomers" table
			And I select current line in "AdvanceFromRetailCustomers" table
			And I click choice button of "Retail customer" attribute in "AdvanceFromRetailCustomers" table
			And I go to line in "List" table
				| 'Description'      |
				| 'Daniel Smith'     |
			And I select current line in "List" table
			And I activate "Currency" field in "AdvanceFromRetailCustomers" table
			And I click choice button of "Currency" attribute in "AdvanceFromRetailCustomers" table
			And I go to line in "List" table
				| 'Code'     |
				| 'TRY'      |
			And I select current line in "List" table
			And I activate "Amount" field in "AdvanceFromRetailCustomers" table
			And I input "1 000,00" text in "Amount" field of "AdvanceFromRetailCustomers" table
			And I finish line editing in "AdvanceFromRetailCustomers" table
		* Add second line
			And in the table "AdvanceFromRetailCustomers" I click "Add" button
			And I activate "Retail customer" field in "AdvanceFromRetailCustomers" table
			And I select current line in "AdvanceFromRetailCustomers" table
			And I click choice button of "Retail customer" attribute in "AdvanceFromRetailCustomers" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Sam Jons'        |
			And I select current line in "List" table
			And I activate "Currency" field in "AdvanceFromRetailCustomers" table
			And I click choice button of "Currency" attribute in "AdvanceFromRetailCustomers" table
			And I go to line in "List" table
				| 'Code'     |
				| 'TRY'      |
			And I select current line in "List" table
			And I activate "Amount" field in "AdvanceFromRetailCustomers" table
			And I input "1 000,00" text in "Amount" field of "AdvanceFromRetailCustomers" table
			And I finish line editing in "AdvanceFromRetailCustomers" table
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry400014$$" variable
		And I delete "$$OpeningEntry400014$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry400014$$"
		And I save the window as "$$OpeningEntry400014$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberOpeningEntry400014$$'    |
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberOpeningEntry400014$$'    |
		And I select current line in "List" table
	* Check change sum
		And I go to line in "AdvanceFromRetailCustomers" table
			| 'Amount'     | 'Currency'   | 'Retail customer'    |
			| '1 000,00'   | 'TRY'        | 'Sam Jons'           |
		And I select current line in "AdvanceFromRetailCustomers" table
		And I input "1 200,00" text in "Amount" field of "AdvanceFromRetailCustomers" table
		And I finish line editing in "AdvanceFromRetailCustomers" table
		And I click "Save" button
		And "AdvanceFromRetailCustomers" table contains lines
			| 'Amount'     | 'Retail customer'   | 'Currency'    |
			| '1 200,00'   | 'Sam Jons'          | 'TRY'         |
		And I close all client application windows

Scenario: _400019 create OpeningEntry (cash in transit)
	And I close all client application windows
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
	* Filling cash in transit tab
		And I move to "Cash in transit" tab
		And in the table "CashInTransit" I click the button named "CashInTransitAdd"
		And I activate field named "CashInTransitAccount" in "CashInTransit" table
		And I select current line in "CashInTransit" table
		And I click choice button of the attribute named "CashInTransitAccount" in "CashInTransit" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, EUR' |
		And I select current line in "List" table
		And I activate "Receipting account" field in "CashInTransit" table
		And I click choice button of "Receipting account" attribute in "CashInTransit" table
		And I go to line in "List" table
			| 'Description'         |
			| 'Bank account 2, EUR' |
		And I select current line in "List" table
		And I click choice button of "Receipting branch" attribute in "CashInTransit" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I activate field named "CashInTransitAmount" in "CashInTransit" table
		And I input "50,00" text in the field named "CashInTransitAmount" of "CashInTransit" table
		And I finish line editing in "CashInTransit" table
		And in the table "CashInTransit" I click the button named "CashInTransitAdd"
		And I activate field named "CashInTransitAccount" in "CashInTransit" table
		And I select current line in "CashInTransit" table
		And I click choice button of the attribute named "CashInTransitAccount" in "CashInTransit" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №1' |
		And I select current line in "List" table
		And I activate "Receipting account" field in "CashInTransit" table
		And I click choice button of "Receipting account" attribute in "CashInTransit" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №4' |
		And I select current line in "List" table
		And I click choice button of "Receipting branch" attribute in "CashInTransit" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I activate field named "CashInTransitAmount" in "CashInTransit" table
		And I input "50,00" text in the field named "CashInTransitAmount" of "CashInTransit" table
		And I finish line editing in "CashInTransit" table
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry400019$$" variable
		And I delete "$$OpeningEntry400019$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry400019$$"
		And I save the window as "$$OpeningEntry400019$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberOpeningEntry400019$$'    |



Scenario: _400020 create OpeningEntry (account payble other and account receivable other)
	And I close all client application windows
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
	* Filling Account payble (other)
		And I move to "Account payable (other)" tab
		And in the table "AccountPayableOther" I click the button named "AccountPayableOtherAdd"
		And I click choice button of the attribute named "AccountPayableOtherPartner" in "AccountPayableOther" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Other partner 1' |
		And I select current line in "List" table
		And I activate field named "AccountPayableOtherAmount" in "AccountPayableOther" table
		And I input "50,00" text in the field named "AccountPayableOtherAmount" of "AccountPayableOther" table
		And I finish line editing in "AccountPayableOther" table
		And in the table "AccountPayableOther" I click the button named "AccountPayableOtherAdd"
		And I click choice button of the attribute named "AccountPayableOtherPartner" in "AccountPayableOther" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Other partner 2' |
		And I select current line in "List" table
		And I activate field named "AccountPayableOtherAmount" in "AccountPayableOther" table
		And I input "70,00" text in the field named "AccountPayableOtherAmount" of "AccountPayableOther" table
		And I finish line editing in "AccountPayableOther" table
		And I move to "Account receivable (other)" tab
		And in the table "AccountReceivableOther" I click the button named "AccountReceivableOtherAdd"
		And I click choice button of the attribute named "AccountReceivableOtherPartner" in "AccountReceivableOther" table
		And I go to line in "List" table
			| 'Description' |
			| 'Other partner 2'       |
		And I select current line in "List" table
		And I activate field named "AccountReceivableOtherAmount" in "AccountReceivableOther" table
		And I input "10,00" text in the field named "AccountReceivableOtherAmount" of "AccountReceivableOther" table
		And I finish line editing in "AccountReceivableOther" table
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry400020$$" variable
		And I delete "$$OpeningEntry400020$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry400020$$"
		And I save the window as "$$OpeningEntry400020$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberOpeningEntry400020$$'    |	

Scenario: _400023 create OpeningEntry (employee)
	And I close all client application windows
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
	* Filling Salary payment
		And I move to "Employee" tab
		* Add first line
			And in the table "EmployeeList" I click the button named "EmployeeListAdd"
			And I activate field named "EmployeeListEmployee" in "EmployeeList" table
			And I select current line in "EmployeeList" table
			And I click choice button of the attribute named "EmployeeListEmployee" in "EmployeeList" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Anna Petrova' |
			And I select current line in "List" table
			And I activate "Position" field in "EmployeeList" table
			And I select "Sales person" from "Position" drop-down list by string in "EmployeeList" table
			And I activate "Employee schedule" field in "EmployeeList" table
			And I click choice button of "Employee schedule" attribute in "EmployeeList" table
			And I go to line in "List" table
				| 'Description'                      | 'Type' |
				| '1 working day / 2 days off (day)' | 'Day'  |
			And I select current line in "List" table
			And I activate field named "EmployeeListProfitLossCenter" in "EmployeeList" table
			And I select "Shop 01" by string from the drop-down list named "EmployeeListProfitLossCenter" in "EmployeeList" table
			And I activate "Accrual type" field in "EmployeeList" table
			And I click choice button of "Accrual type" attribute in "EmployeeList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Salary'      |
			And I select current line in "List" table
			And I activate "Salary type" field in "EmployeeList" table
			And I select "By position" exact value from "Salary type" drop-down list in "EmployeeList" table
			And I finish line editing in "EmployeeList" table
			And I input "10" text in "Remaining vacation days" field of "EmployeeList" table
			And I finish line editing in "EmployeeList" table
		* Add second line
			And in the table "EmployeeList" I click the button named "EmployeeListAdd"
			And I click choice button of "Salary type" attribute in "EmployeeList" table
			And I activate field named "EmployeeListEmployee" in "EmployeeList" table
			And I click choice button of the attribute named "EmployeeListEmployee" in "EmployeeList" table
			And I go to line in "List" table
				| 'Description'   |
				| 'David Romanov' |
			And I select current line in "List" table
			And I activate "Position" field in "EmployeeList" table
			And I select "Manager" from "Position" drop-down list by string in "EmployeeList" table
			And I activate "Employee schedule" field in "EmployeeList" table
			And I select "5 working days / 2 days off (day)" from "Employee schedule" drop-down list by string in "EmployeeList" table
			And I activate field named "EmployeeListProfitLossCenter" in "EmployeeList" table
			And I select "Front office" by string from the drop-down list named "EmployeeListProfitLossCenter" in "EmployeeList" table
			And I activate "Accrual type" field in "EmployeeList" table
			And I select "Salary" from "Accrual type" drop-down list by string in "EmployeeList" table
			And I activate "Salary type" field in "EmployeeList" table
			And I select "Personal" exact value from "Salary type" drop-down list in "EmployeeList" table
			And I finish line editing in "EmployeeList" table
			And I activate "Salary" field in "EmployeeList" table
			And I select current line in "EmployeeList" table
			And I input "10 000,00" text in "Salary" field of "EmployeeList" table
			And I finish line editing in "EmployeeList" table
			And I activate "Remaining vacation days" field in "EmployeeList" table
			And I select current line in "EmployeeList" table
			And I input "5" text in "Remaining vacation days" field of "EmployeeList" table
			And I finish line editing in "EmployeeList" table
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry400023$$" variable
		And I delete "$$OpeningEntry400023$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry400023$$"
		And I save the window as "$$OpeningEntry400023$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberOpeningEntry400023$$'    |			