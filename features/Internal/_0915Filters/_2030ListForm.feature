#language: en
@tree
@Positive
@Filters

Feature: check the display of lists of catalogs elements for which there are selections



Background:
	Given I launch TestClient opening script or connect the existing one

	

Scenario: _203000 preparation (List forms)
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

Scenario: _0203001 check filters in the partner term catalog
	* Check for data availability
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And "List" table contains lines
		| 'Description'                             |
		| 'Basic Partner terms, TRY'                   |
		| 'Vendor Ferron, TRY'                      |
		And I close all client application windows
	* Filter check according to partner term with customers in the sales section
		* Open list form
			When in sections panel I select "Sales - A/R"
			And in functions panel I select "Customers partner terms"
		* Filter check
			And "List" table does not contain lines
			| 'Description'                             |
			| 'Vendor Ferron, TRY'                      |
			And "List" table contains lines
			| 'Description'                             |
			| 'Basic Partner terms, TRY'                   |
	* Filter check according to partner term with vendors in the purchase section
		* Open list form
			When in sections panel I select "Purchase  - A/P"
			And in functions panel I select "Vendors partner terms"
		* Filter check
			And "List" table contains lines
			| 'Description'                             |
			| 'Vendor Ferron, TRY'                      |
			And "List" table does not contain lines
			| 'Description'                             |
			| 'Basic Partner terms, TRY'                   |
	And I close all client application windows

Scenario: _0203002 check filters in the partner catalog
	* Check for data availability
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And "List" table contains lines
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Kalipso'          |
			| 'Nicoletta'        |
			| 'Veritas'          |
		And I close all client application windows
	* Filter check customers in the sales section
		* Open list form
			When in sections panel I select "Sales - A/R"
			And in functions panel I select "Customers"
		* Check the selection by customer
			And "List" table does not contain lines
			| 'Description'      |
			| 'Veritas'          |
			And "List" table contains lines
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Kalipso'          |
			| 'Nicoletta'        |
		* Filter check customers who are suppliers also
			And I set checkbox "Vendor"
			And "List" table does not contain lines
			| 'Description'      |
			| 'Kalipso'          |
		And I close all client application windows
	* Filter check customers in the purchase section
		* Open list form
			When in sections panel I select "Purchase  - A/P"
			And in functions panel I select "Vendors"
		* Check the selection by vendors
			And "List" table contains lines
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Veritas'          |
			| 'Nicoletta'        |
			And "List" table does not contain lines
			| 'Description'      |
			| 'Kalipso'          |
		* Filter check for vendors that are also customers
			And I set checkbox "Customer"
			And "List" table does not contain lines
			| 'Description'      |
			| 'Veritas'          |
		And I close all client application windows
	* Check filters in the catalog Partners
		* Open catalog
			Given I open hyperlink "e1cib/list/Catalog.Partners"
		* Check the selection by customer
			And I set checkbox "Customer"
			And "List" table contains lines
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Kalipso'          |
			| 'Nicoletta'        |
			And "List" table does not contain lines
			| 'Description'      |
			| 'Veritas'          |
		* Check the selection by vendor
			And I remove checkbox "Customer"
			And I set checkbox "Vendor"
			And "List" table does not contain lines
			| 'Description'      |
			| 'Kalipso'          |
			And "List" table contains lines
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Veritas'          |
			| 'Nicoletta'        |
		* Check the selection by employee
			And I remove checkbox "Vendor"
			And I set checkbox "Employee"
			And "List" table does not contain lines
			| 'Description'      |
			| 'Ferron BP'        |
			| 'Kalipso'          |
			| 'Nicoletta'        |
			| 'Veritas'          |
			And "List" table contains lines
			| 'Description'     |
			| 'Alexander Orlov' |
			| 'Anna Petrova'    |
			| 'David Romanov'   |
			| 'Arina Brown'     |
		* Check the selection by opponent
			And I set checkbox "Opponent"
			And I remove checkbox "Employee"
			Then the number of "List" table lines is "равно" 0
		And I close all client application windows





Scenario: _0203003 check filters in the Cash/Bank accounts catalog
	* Check for data availability
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And "List" table contains lines
			| 'Description'      |
			| 'Cash desk №1'     |
			| 'Cash desk №2'     |
			| 'Transit Main'     |
			| 'Transit Second'   |
			| 'Bank account, TRY'|
			| 'Bank account, USD'|
	* Check the selection by cash account
		And I change "CashAccountTypeFilter" radio button value to "Cash"
		And "List" table contains lines
			| 'Description'      |
			| 'Cash desk №1'     |
			| 'Cash desk №2'     |
		And "List" table does not contain lines
			| 'Description'      |
			| 'Transit Main'     |
			| 'Transit Second'   |
			| 'Bank account, TRY'|
			| 'Bank account, USD'|
	* Check the selection by bank account
		And I change "CashAccountTypeFilter" radio button value to "Bank"
		And "List" table contains lines
			| 'Description'      |
			| 'Bank account, TRY'|
			| 'Bank account, USD'|
		And "List" table does not contain lines
			| 'Description'      |
			| 'Transit Main'     |
			| 'Transit Second'   |
			| 'Cash desk №1'     |
			| 'Cash desk №2'     |
	* Check the selection by transit account
		And I change "CashAccountTypeFilter" radio button value to "Transit"
		And "List" table contains lines
			| 'Description'      |
			| 'Transit Main'     |
			| 'Transit Second'   |
		And "List" table does not contain lines
			| 'Description'      |
			| 'Bank account, TRY'|
			| 'Bank account, USD'|
			| 'Cash desk №1'     |
			| 'Cash desk №2'     |
	* Filter reset check
		And I change "CashAccountTypeFilter" radio button value to "All"
		And "List" table contains lines
			| 'Description'      |
			| 'Cash desk №1'     |
			| 'Cash desk №2'     |
			| 'Transit Main'     |
			| 'Transit Second'   |
			| 'Bank account, TRY'|
			| 'Bank account, USD'|
		And I close all client application windows



