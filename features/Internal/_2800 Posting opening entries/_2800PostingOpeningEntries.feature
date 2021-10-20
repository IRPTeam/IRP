#language: en
@tree
@Positive
@OpeningEntries

Feature: check opening entry

As a developer
I want to create a document to enter the opening balance
To input the client's balance when you start working with the base

Background:
	Given I launch TestClient opening script or connect the existing one



# it's necessary to add tests to start the remainder of the documents
Scenario: _400000 preparation (Opening entries)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
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
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
		When add sales tax settings 
	


Scenario: _400001 opening entry account balance
	* Open document form for opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Filling in the tabular part account balance
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I click choice button of "Currency" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "1 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description  |
			| Cash desk №2 |
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I click choice button of "Currency" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Code | Description     |
			| USD  | American dollar |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "1 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description  |
			| Cash desk №3 |
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I click choice button of "Currency" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Code | Description |
			| EUR  | Euro        |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "1 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description       |
			| Bank account, TRY |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "10 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description       |
			| Bank account, USD |
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "5 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description       |
			| Bank account, EUR |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "8 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
	* Check filling in currency rate
		* Filling in currency rate Cash desk №3
			And I go to line in "AccountBalance" table
				| 'Account'      | 'Amount'   | 'Currency' |
				| 'Cash desk №3' | '1 000,00' | 'EUR'      |
			And I activate "Account" field in "AccountBalance" table
			And in the table "AccountBalance" I click "Edit currencies account balance" button
			And I activate "Rate" field in "CurrenciesTable" table
			And I input "5,6883" text in "Rate" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And I go to line in "CurrenciesTable" table
				| 'From' | 'Movement type'      | 'Multiplicity' | 'To'  | 'Type'      |
				| 'EUR'  | 'Reporting currency' | '1'            | 'USD' | 'Reporting' |
			And I select current line in "CurrenciesTable" table
			And I input "1,1000" text in "Rate" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And I click "Ok" button		
		* Filling in currency rate Bank account, EUR
			And I go to line in "AccountBalance" table
				| 'Account'           | 'Currency' |
				| 'Bank account, EUR' | 'EUR'      |
			And I activate "Account" field in "AccountBalance" table
			And in the table "AccountBalance" I click "Edit currencies account balance" button
			And I activate "Rate" field in "CurrenciesTable" table
			And I input "5,6883" text in "Rate" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And I go to line in "CurrenciesTable" table
				| 'From' | 'Movement type'      | 'Multiplicity' | 'To'  | 'Type'      |
				| 'EUR'  | 'Reporting currency' | '1'            | 'USD' | 'Reporting' |
			And I select current line in "CurrenciesTable" table
			And I input "1,1000" text in "Rate" field of "CurrenciesTable" table
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
			| 'Number' |
			|  '$$NumberOpeningEntry400001$$'    |




Scenario: _400002 opening entry inventory balance
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Filling in the tabular part Inventory
		And I move to "Inventory" tab
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Dress | XS/Blue  |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 01    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "500,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Dress | S/Yellow |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 02    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "400,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Dress | XS/Blue  |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 01    |
		And I select current line in "List" table
		And I finish line editing in "Inventory" table
		And I activate "Quantity" field in "Inventory" table
		And I select current line in "Inventory" table
		And I input "400,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item     | Item key  |
			| Trousers | 38/Yellow |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 02    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item     | Item key  |
			| Trousers | 38/Yellow |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 01    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Shirt | 36/Red   |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 02    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Shirt | 36/Red   |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 01    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Boots | 36/18SD  |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 02    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "200,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Boots | 36/18SD  |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 01    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "300,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Dress | L/Green  |
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
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Dress | L/Green  |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 02    |
		And I select current line in "List" table
		And I finish line editing in "Inventory" table
		And I go to line in "Inventory" table
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'L/Green'  | '500,000'  | 'Store 01' |
		And I activate "Quantity" field in "Inventory" table
		And I go to line in "Inventory" table
			| Item key | Store    |
			| L/Green  | Store 02 |
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
			| 'Number' |
			|  '$$NumberOpeningEntry400002$$'    |
	

Scenario: _400003 opening entry advance balance
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
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
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I activate field named "AdvanceFromCustomersCurrency" in "AdvanceFromCustomers" table
		And I click choice button of the attribute named "AdvanceFromCustomersCurrency" in "AdvanceFromCustomers" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I activate field named "AdvanceFromCustomersAmount" in "AdvanceFromCustomers" table
		And I input "100,00" text in the field named "AdvanceFromCustomersAmount" of "AdvanceFromCustomers" table
		And I finish line editing in "AdvanceFromCustomers" table
	* Filling in AdvanceToSuppliers
		And I move to "To suppliers" tab
		And in the table "AdvanceToSuppliers" I click the button named "AdvanceToSuppliersAdd"
		And I click choice button of the attribute named "AdvanceToSuppliersPartner" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I finish line editing in "AdvanceToSuppliers" table
		And I activate field named "AdvanceToSuppliersLegalName" in "AdvanceToSuppliers" table
		And I select current line in "AdvanceToSuppliers" table
		And I click choice button of the attribute named "AdvanceToSuppliersLegalName" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I activate field named "AdvanceToSuppliersCurrency" in "AdvanceToSuppliers" table
		And I click choice button of the attribute named "AdvanceToSuppliersCurrency" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
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
			| 'Number' |
			|  '$$NumberOpeningEntry400003$$'    |
		And I close all client application windows


Scenario: _400004 opening entry Vendors transaction by partner terms (vendors)
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Filling in Account payable
		* Filling in partner and Legal name
			And I move to "Account payable" tab
			And in the table "AccountPayableByAgreements" I click "Add" button
			And I click choice button of "Partner" attribute in "AccountPayableByAgreements" table
			And I go to line in "List" table
				| 'Description' |
				| 'DFC'         |
			And I select current line in "List" table
			And I finish line editing in "AccountPayableByAgreements" table
		* Check filling in legal name
				And "AccountPayableByAgreements" table contains lines
				| 'Partner' | 'Legal name' |
				| 'DFC'     | 'DFC'        |
		* Create test partner term with AP/AR posting detail - By partner terms (type Vendor)
			And I click choice button of "Partner term" attribute in "AccountPayableByAgreements" table
			And I click the button named "FormCreate"
			And I change "AP/AR posting detail" radio button value to "By partner terms"
			And I change "Type" radio button value to "Vendor"
			And I input "DFC Vendor by Partner terms" text in the field named "Description_en"
			And I input "01.12.2019" text in "Date" field
			And I click Select button of "Multi currency movement type" field
			And I go to line in "List" table
				| 'Currency' | 'Description' | 'Source'       | 'Type'      |
				| 'TRY'      | 'TRY'         | 'Forex Seling' | 'Partner term' |
			And I select current line in "List" table
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| 'Currency' | 'Description'       | 'Reference'         |
				| 'TRY'      | 'Vendor price, TRY' | 'Vendor price, TRY' |
			And I select current line in "List" table
			And I input "01.12.2019" text in "Start using" field
			And I click "Save and close" button
			And I go to line in "List" table
			| 'Description'              |
			| 'DFC Vendor by Partner terms' |
			And I click the button named "FormChoose"
		* Filling in amount and currency
			And I activate "Currency" field in "AccountPayableByAgreements" table
			And I select current line in "AccountPayableByAgreements" table
			And I click choice button of "Currency" attribute in "AccountPayableByAgreements" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I activate "Amount" field in "AccountPayableByAgreements" table
			And I input "100,00" text in "Amount" field of "AccountPayableByAgreements" table
			And I finish line editing in "AccountPayableByAgreements" table
		* Check calculation Reporting currency
			And in the table "AccountPayableByAgreements" I click "Edit currencies account payable by agreements" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '17,12'  |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |
				| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |
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
			| 'Number' |
			|  '$$NumberOpeningEntry400004$$'    |
		And I close all client application windows

	
Scenario: _400005 opening entry Customers transactions by partner terms (customers)
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Filling in Account receivable
		* Filling in partner and Legal name
			And I move to "Account receivable" tab
			And in the table "AccountReceivableByAgreements" I click "Add" button
			And I click choice button of "Partner" attribute in "AccountReceivableByAgreements" table
			And I go to line in "List" table
				| 'Description' |
				| 'DFC'         |
			And I select current line in "List" table
			And I finish line editing in "AccountReceivableByAgreements" table
		* Check filling in legal name
				And "AccountReceivableByAgreements" table contains lines
				| 'Partner' | 'Legal name' |
				| 'DFC'     | 'DFC'        |
		* Create test partner term with AP/AR posting detail - By partner terms (type Customer)
			And I click choice button of "Partner term" attribute in "AccountReceivableByAgreements" table
			And I click the button named "FormCreate"
			And I change "AP/AR posting detail" radio button value to "By partner terms"
			And I change "Type" radio button value to "Customer"
			And I input "DFC Customer by Partner terms" text in the field named "Description_en"
			And I input "01.12.2019" text in "Date" field
			And I click Select button of "Multi currency movement type" field
			And I go to line in "List" table
				| 'Currency' | 'Description' | 'Source'       | 'Type'      |
				| 'TRY'      | 'TRY'         | 'Forex Seling' | 'Partner term' |
			And I select current line in "List" table
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I input "01.12.2019" text in "Start using" field
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description'              |
				| 'DFC Customer by Partner terms' |
			And I click the button named "FormChoose"
		* Filling in amount and currency
			And I activate "Currency" field in "AccountReceivableByAgreements" table
			And I select current line in "AccountReceivableByAgreements" table
			And I click choice button of "Currency" attribute in "AccountReceivableByAgreements" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I activate "Amount" field in "AccountReceivableByAgreements" table
			And I input "100,00" text in "Amount" field of "AccountReceivableByAgreements" table
			And I finish line editing in "AccountReceivableByAgreements" table
		* Check calculation Reporting currency
			And in the table "AccountReceivableByAgreements" I click "Edit currencies account receivable by agreements" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '17,12'  |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |
				| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |
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
			| 'Number' |
			|  '$$NumberOpeningEntry400005$$'    |
		And I close all client application windows



Scenario: _400008 check the entry of the account balance, inventory balance, customers and vendors transactions, advance in one document
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Filling in the tabular part Account Balance
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description  |
			| Cash desk №2 |
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I click choice button of "Currency" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Code | Description     |
			| USD  | American dollar |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "1 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
	* Filling in the tabular part Inventory
		And I move to "Inventory" tab
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Dress | XS/Blue  |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 01    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "10,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
	* Filling in Advance from Customers
		And in the table "AdvanceFromCustomers" I click the button named "AdvanceFromCustomersAdd"
		And I click choice button of the attribute named "AdvanceFromCustomersPartner" in "AdvanceFromCustomers" table
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I activate field named "AdvanceFromCustomersCurrency" in "AdvanceFromCustomers" table
		And I click choice button of the attribute named "AdvanceFromCustomersCurrency" in "AdvanceFromCustomers" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I activate field named "AdvanceFromCustomersAmount" in "AdvanceFromCustomers" table
		And I input "525,00" text in the field named "AdvanceFromCustomersAmount" of "AdvanceFromCustomers" table
		And I finish line editing in "AdvanceFromCustomers" table
	* Filling in Advance to suppliers
		And I move to "To suppliers" tab
		And in the table "AdvanceToSuppliers" I click the button named "AdvanceToSuppliersAdd"
		And I click choice button of the attribute named "AdvanceToSuppliersPartner" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I finish line editing in "AdvanceToSuppliers" table
		And I activate field named "AdvanceToSuppliersLegalName" in "AdvanceToSuppliers" table
		And I select current line in "AdvanceToSuppliers" table
		And I click choice button of the attribute named "AdvanceToSuppliersLegalName" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I activate field named "AdvanceToSuppliersCurrency" in "AdvanceToSuppliers" table
		And I click choice button of the attribute named "AdvanceToSuppliersCurrency" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
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
				| 'Description' |
				| 'DFC'         |
			And I select current line in "List" table
			And I finish line editing in "AccountPayableByAgreements" table
		* Check filling in legal name
				And "AccountPayableByAgreements" table contains lines
				| 'Partner' | 'Legal name' |
				| 'DFC'     | 'DFC'        |
		* Select partner term
			And I click choice button of "Partner term" attribute in "AccountPayableByAgreements" table
			And I go to line in "List" table
			| 'Description'              |
			| 'DFC Vendor by Partner terms' |
			And I click the button named "FormChoose"
		* Filling in amount and currency
			And I activate "Currency" field in "AccountPayableByAgreements" table
			And I select current line in "AccountPayableByAgreements" table
			And I click choice button of "Currency" attribute in "AccountPayableByAgreements" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
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
				| 'Description' |
				| 'DFC'         |
			And I select current line in "List" table
			And I finish line editing in "AccountReceivableByAgreements" table
		* Check filling in legal name
				And "AccountReceivableByAgreements" table contains lines
				| 'Partner' | 'Legal name' |
				| 'DFC'     | 'DFC'        |
		* Select partner term
			And I click choice button of "Partner term" attribute in "AccountReceivableByAgreements" table
			And I go to line in "List" table
				| 'Description'              |
				| 'DFC Customer by Partner terms' |
			And I click the button named "FormChoose"
		* Filling in amount and currency
			And I activate "Currency" field in "AccountReceivableByAgreements" table
			And I select current line in "AccountReceivableByAgreements" table
			And I click choice button of "Currency" attribute in "AccountReceivableByAgreements" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I activate "Amount" field in "AccountReceivableByAgreements" table
			And I input "151,00" text in "Amount" field of "AccountReceivableByAgreements" table
			And I finish line editing in "AccountReceivableByAgreements" table
		* Check calculation Reporting currency
			And in the table "AccountReceivableByAgreements" I click "Edit currencies account receivable by agreements" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '25,85'  |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '151'    |
				| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '151'    |
			And I close current window			
			And I click the button named "FormPost"
			And I delete "$$NumberOpeningEntry400008$$" variable
			And I delete "$$OpeningEntry400008$$" variable
			And I save the value of "Number" field as "$$NumberOpeningEntry400008$$"
			And I save the window as "$$OpeningEntry400008$$"
		* Check creation
			Given I open hyperlink "e1cib/list/Document.OpeningEntry"
			And "List" table contains lines
				| 'Number' |
				|  '$$NumberOpeningEntry400008$$'    |
			And I close all client application windows

		


Scenario: _400009 check the entry of the Vendors/Customers transactions by documents (with payment terms)
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in AP by documents first string
		And I move to "Account payable" tab
		And I move to the tab named "GroupAccountPayableByDocuments"
		And in the table "AccountPayableByDocuments" I click the button named "AccountPayableByDocumentsAdd"
		And I click choice button of the attribute named "AccountPayableByDocumentsPartner" in "AccountPayableByDocuments" table
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I finish line editing in "AccountPayableByDocuments" table
		And I move to the next attribute
		And I activate field named "AccountPayableByDocumentsAgreement" in "AccountPayableByDocuments" table
		And I click choice button of the attribute named "AccountPayableByDocumentsAgreement" in "AccountPayableByDocuments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor DFC'         |
		And I select current line in "List" table
		And I select current line in "AccountPayableByDocuments" table
		And I activate field named "AccountPayableByDocumentsCurrency" in "AccountPayableByDocuments" table
		And I click choice button of the attribute named "AccountPayableByDocumentsCurrency" in "AccountPayableByDocuments" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
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
			| 'Description' |
			| 'DFC'         |
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
			| 'Description' |
			| 'Euro'        |
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
			| '#' |
			| '1' |
		And I activate "Key" field in "AccountPayableByDocuments" table
		And I delete "$$Rov1OpeningEntry400009$$" variable
		And I save the current field value as "$$Rov1OpeningEntry400009$$"
		And I go to line in "AccountPayableByDocuments" table
			| '#' |
			| '2' |
		And I activate "Key" field in "AccountPayableByDocuments" table
		And I delete "$$Rov2OpeningEntry400009$$" variable
		And I save the current field value as "$$Rov2OpeningEntry400009$$"
		And "AccountPayableByDocuments" table contains lines
			| 'Key'                        | '#' | 'Partner' | 'Amount' | 'Legal name' | 'Partner term'            | 'Currency' |
			| '$$Rov1OpeningEntry400009$$' | '1' | 'DFC'     | '100,00' | 'DFC'        | 'Partner term vendor DFC' | 'TRY'      |
			| '$$Rov2OpeningEntry400009$$' | '2' | 'DFC'     | '200,00' | 'DFC'        | 'Partner term vendor DFC' | 'EUR'      |
		And "VendorsPaymentTerms" table contains lines
			| 'Key'                        | 'Calculation type'     | 'Date'       | 'Amount' |
			| '$$Rov1OpeningEntry400009$$' | 'Post-shipment credit' | '30.12.2022' | '100,00' |
			| '$$Rov2OpeningEntry400009$$' | 'Post-shipment credit' | '30.12.2021' | '200,00' |
	* Filling in AR by documents first string
		And I move to "Account receivable" tab
		And I move to the tab named "GroupAccountReceivableByDocuments"
		And in the table "AccountReceivableByDocuments" I click the button named "AccountReceivableByDocumentsAdd"
		And I click choice button of the attribute named "AccountReceivableByDocumentsPartner" in "AccountReceivableByDocuments" table
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I move to the next attribute
		And I activate field named "AccountReceivableByDocumentsAgreement" in "AccountReceivableByDocuments" table
		And I click choice button of the attribute named "AccountReceivableByDocumentsAgreement" in "AccountReceivableByDocuments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term DFC'         |
		And I select current line in "List" table
		And I activate field named "AccountReceivableByDocumentsCurrency" in "AccountReceivableByDocuments" table
		And I click choice button of the attribute named "AccountReceivableByDocumentsCurrency" in "AccountReceivableByDocuments" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
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
			| 'Description' |
			| 'Lomaniti'    |
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
			| 'Description'  |
			| 'Turkish lira' |
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
			| '#' |
			| '1' |
		And I activate "Key" field in "AccountReceivableByDocuments" table
		And I delete "$$Rov3OpeningEntry400009$$" variable
		And I save the current field value as "$$Rov3OpeningEntry400009$$"
		And I go to line in "AccountReceivableByDocuments" table
			| '#' |
			| '2' |
		And I activate "Key" field in "AccountReceivableByDocuments" table
		And I delete "$$Rov4OpeningEntry400009$$" variable
		And I save the current field value as "$$Rov4OpeningEntry400009$$"
		And "AccountReceivableByDocuments" table contains lines
			| 'Key'                        | '#' | 'Partner'  | 'Amount' | 'Legal name'       | 'Partner term'             | 'Currency' |
			| '$$Rov3OpeningEntry400009$$' | '1' | 'DFC'      | '200,00' | 'DFC'              | 'Partner term DFC'         | 'TRY'      |
			| '$$Rov4OpeningEntry400009$$' | '2' | 'Lomaniti' | '100,00' | 'Company Lomaniti' | 'Basic Partner terms, TRY' | 'TRY'      |
		And "CustomersPaymentTerms" table contains lines
			| 'Key'                        | 'Calculation type'     | 'Date'       | 'Amount' |
			| '$$Rov3OpeningEntry400009$$' | 'Post-shipment credit' | '31.12.2022' | '200,00' |
			| '$$Rov4OpeningEntry400009$$' | 'Post-shipment credit' | '21.12.2021' | '100,00'  |
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
			| '#' | 'Amount' | 'Currency' | 'Key'                        | 'Legal name'       | 'Partner'  | 'Partner term'             |
			| '2' | '100,00' | 'TRY'      | '$$Rov4OpeningEntry400009$$' | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' |
		And I delete a line in "AccountReceivableByDocuments" table
		And "CustomersPaymentTerms" table does not contain lines
			| 'Key'                        | 'Calculation type'     | 'Date'       | 'Amount' |
			| '$$Rov4OpeningEntry400009$$' | 'Post-shipment credit' | '21.12.2021' | '100,00'  |
	* Check clearing of payment conditions when deleting a line (VendorsPaymentTerms)
		And I move to "Account payable" tab
		And I go to line in "AccountPayableByDocuments" table
			| '#' | 'Amount' | 'Currency' | 'Key'                        | 'Legal name' | 'Partner' | 'Partner term'            |
			| '1' | '100,00' | 'TRY'      | '$$Rov1OpeningEntry400009$$' | 'DFC'        | 'DFC'     | 'Partner term vendor DFC' |
		And I delete a line in "AccountPayableByDocuments" table
		And "VendorsPaymentTerms" table does not contain lines
			| 'Key'                        | 'Calculation type'     | 'Date'       | 'Amount' |
			| '$$Rov1OpeningEntry400009$$' | 'Post-shipment credit' | '30.12.2022' | '100,00' |
		And I click the button named "FormPostAndClose"		
	* Check creation
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And "List" table contains lines
			| 'Number' |
			|  '$$NumberOpeningEntry400009$$'    |
		And I close all client application windows

		
	
Scenario: _999999 close TestClient session
	And I close TestClient session