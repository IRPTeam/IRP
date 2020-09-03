#language: en
@tree
@Positive
@Test1
@Group1

Feature: filling in catalogs

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"



Scenario: _005010 filling in the "Countries" catalog
	* Clearing the Countries catalog
		And I close all client application windows
	* Opening the Country creation form
		Given I open hyperlink "e1cib/list/Catalog.Countries"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
	* Data Filling - Turkey
		And I click Open button of the field named "Description_en"
		And I input "Turkey" text in the field named "Description_en"
		And I input "Turkey TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Data Filling - Ukraine and Kazakhstan
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Ukraine" text in the field named "Description_en"
		And I input "Ukraine TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Kazakhstan" text in the field named "Description_en"
		And I input "Kazakhstan TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Check for added countries in the catalog
		Then I check for the "Countries" catalog element with the "Description_en" "Turkey"
		Then I check for the "Countries" catalog element with the "Description_tr" "Turkey TR"
		Then I check for the "Countries" catalog element with the "Description_en" "Kazakhstan"
		Then I check for the "Countries" catalog element with the "Description_en" "Ukraine"



Scenario: _005011 filling in the "Currencies" catalog
	* Opening the Currency creation form
		Given I open hyperlink "e1cib/list/Catalog.Currencies"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
	* Creating currencies: Turkish lira, American dollar, Euro, Ukraine Hryvnia
		And I click Open button of the field named "Description_en"
		And I input "Turkish lira" text in the field named "Description_en"
		And I input "Turkish lira" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "TL" text in "Symbol" field
		And I input "TRY" text in "Code" field
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "American dollar" text in the field named "Description_en"
		And I input "American dollar" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "$" text in "Symbol" field
		And I input "USD" text in "Code" field
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Euro" text in the field named "Description_en"
		And I input "Euro" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "€" text in "Symbol" field
		And I input "EUR" text in "Code" field
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Ukraine Hryvnia" text in the field named "Description_en"
		And I input "Ukraine Hryvnia" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "₴" text in "Symbol" field
		And I input "UAH" text in "Code" field
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Check for added currencies in the catalog
		Then I check for the "Currencies" catalog element with the "Description_en" "Turkish lira"
		Then I check for the "Currencies" catalog element with the "Description_tr" "Turkish lira"
		Then I check for the "Currencies" catalog element with the "Description_en" "American dollar"
		Then I check for the "Currencies" catalog element with the "Description_en" "Euro"
		Then I check for the "Currencies" catalog element with the "Description_en" "Ukraine Hryvnia"


Scenario: _005012 create integration settings to load the currency rate (without Plugin sessing connected)
	* Creating a setting to download the Forex Seling course (tcmb.gov.tr)
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "Forex Seling" text in "Description" field
		And I input "ForexSeling" text in "Unique ID" field
		And I click "Save" button
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description'    |
			| 'ExternalTCMBGovTr' |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 10
	* Creating a setting to download the Forex Buying course (tcmb.gov.tr)
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "Forex Buying" text in "Description" field
		And I input "ForexBuying" text in "Unique ID" field
		And I click "Save" button
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description'    |
			| 'ExternalTCMBGovTr' |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 10
	* Creating a setting to download the course (bank.gov.ua)
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "Bank UA" text in "Description" field
		And I input "BankUA" text in "Unique ID" field
		And I click "Save" button
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description'    |
			| 'ExternalBankUa' |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 10



Scenario: _005013 filling in the "Companies" catalog
	* Opening the form for filling in
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
	* Filling in company information
		And I click Open button of the field named "Description_en"
		And I input "Main Company" text in the field named "Description_en"
		And I input "Main Company TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "Turkey" text in the field named "Country"
		And I set checkbox "Our"
		And I select "Company" exact value from the drop-down list named "Type"
		And I click "Save" button
	* Filling in currency information (Local currency and Reporting currency)
		And I move to "Currencies" tab
		* Creation and addition of Local currency
			And in the table "Currencies" I click the button named "CurrenciesAdd"
			And I click choice button of "Movement type" attribute in "Currencies" table
			And I click the button named "FormCreate"
			And I input "Local currency" text in the field named "Description_en"
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I click Select button of "Source" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Forex Seling' |
			And I select current line in "List" table
			And I select "Legal" exact value from "Type" drop-down list
			And I click "Save and close" button
			And Delay 5
			And I click the button named "FormChoose"
			And I finish line editing in "Currencies" table
		* Creation and addition of Reporting currency
			And in the table "Currencies" I click the button named "CurrenciesAdd"
			And I click choice button of "Movement type" attribute in "Currencies" table
			And I click the button named "FormCreate"
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| 'Code' | 'Description'     |
				| 'USD'  | 'American dollar' |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click Select button of "Source" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Forex Seling' |
			And I select current line in "List" table
			And I select "Reporting" exact value from "Type" drop-down list
			And I input "Reporting currency" text in the field named "Description_en"
			And I click "Save and close" button
			And Delay 5
			And I click the button named "FormChoose"
			And I finish line editing in "Currencies" table
		And I click "Save and close" button
		And Delay 5
	* Check the availability of the created company in the catalog
		Then I check for the "Companies" catalog element with the "Description_en" "Main Company" 
		Then I check for the "Companies" catalog element with the "Description_tr" "Main Company TR"


Scenario: _005017 creation Movement Type for Partner term currencies
	* Opening charts of characteristic types - Currency movement
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.CurrencyMovementType"
	* Create currency for Partner terms - TRY
		And I click the button named "FormCreate"
		And I input "TRY" text in the field named "Description_en"
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Source" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Forex Seling' |
		And I select current line in "List" table
		And I select "Partner term" exact value from "Type" drop-down list
		And I click "Save and close" button
	* Create currency for Partner terms - EUR
		And I click the button named "FormCreate"
		And I input "EUR" text in the field named "Description_en"
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code' | 'Description' |
			| 'EUR'  | 'Euro'        |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click Select button of "Source" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Forex Seling' |
		And I select current line in "List" table
		And I select "Partner term" exact value from "Type" drop-down list
		And I click "Save and close" button
	* Create currency for Partner terms - USD
		And I click the button named "FormCreate"
		And I input "USD" text in the field named "Description_en"
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click Select button of "Source" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Forex Seling' |
		And I select current line in "List" table
		And I select "Partner term" exact value from "Type" drop-down list
		And I click "Save and close" button
		And Delay 5


Scenario: _005014 filling in the "Units" catalog
	* Opening the form for filling in "Units"
		Given I open hyperlink "e1cib/list/Catalog.Units"
		And Delay 2
		And I click the button named "FormCreate"
	* Creating a unit of measurement 'pcs'
		And I click Open button of the field named "Description_en"
		And I input "pcs" text in the field named "Description_en"
		And I input "adet" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create a unit of measurement for 4 pcs packaging
		And I click the button named "FormCreate"
		And I click Choice button of the field named "BasisUnit"
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "box (4 pcs)" text in the field named "Description_en"
		And I input "box (4 adet)" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "4" text in the field named "Quantity"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create a unit of measurement for 8 pcs packaging
		And I click the button named "FormCreate"
		And I click Choice button of the field named "BasisUnit"
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "box (8 pcs)" text in the field named "Description_en"
		And I input "box (8 adet)" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "8" text in the field named "Quantity"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create a unit of measurement for 16 pcs packaging
		And I click the button named "FormCreate"
		And I click Choice button of the field named "BasisUnit"
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "box (16 pcs)" text in the field named "Description_en"
		And I input "box (16 adet)" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "16" text in the field named "Quantity"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Check for created elements
		Then I check for the "Units" catalog element with the "Description_en" "pcs"  
		Then I check for the "Units" catalog element with the "Description_tr" "adet"
		Then I check for the "Units" catalog element with the "Description_en" "box (4 pcs)"
		Then I check for the "Units" catalog element with the "Description_en" "box (8 pcs)"
		Then I check for the "Units" catalog element with the "Description_en" "box (16 pcs)"


Scenario: _005015 filling in the "AccessGroups" catalog
	* Opening the form for filling in AccessGroups
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
		And I click the button named "FormCreate"
		And Delay 2
	* Data Filling - Admin
		And I click Open button of the field named "Description_en"
		And I input "Admin" text in the field named "Description_en"
		And I input "Admin TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Check for created AccessGroups
		Then I check for the "AccessGroups" catalog element with the "Description_en" "Admin"  
		Then I check for the "AccessGroups" catalog element with the "Description_tr" "Admin TR"

Scenario: _005016 filling in the "AccessProfiles" catalog
	* Opening the form for filling in AccessProfiles
		Given I open hyperlink "e1cib/list/Catalog.AccessProfiles"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
	* Data Filling - Admin
		And I click Open button of the field named "Description_en"
		And I input "Admin" text in the field named "Description_en"
		And I input "Admin TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named 'RolesUpdateRoles'
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Check for created User access profiles
		Then I check for the "AccessProfiles" catalog element with the "Description_en" "Admin"  
		Then I check for the "AccessProfiles" catalog element with the "Description_tr" "Admin TR"




Scenario: _005018 filling in the "Cash/Bank accounts" catalog
	* Opening the form for filling in Accounts
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And Delay 2
		And I click the button named "FormCreate"
	* Create and check the creation of Cash/Bank accounts: Cash desk №1, Cash desk №2, Cash desk №3
		And I click Open button of the field named "Description_en"
		And I input "Cash desk №1" text in the field named "Description_en"
		And I input "Cash desk №1 TR" text in the field named "Description_tr"
		And I click "Ok" button
		Then the form attribute named "Type" became equal to "Cash"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
		Then I check for the "CashAccounts" catalog element with the "Description_en" "Cash desk №1"  
		Then I check for the "CashAccounts" catalog element with the "Description_tr" "Cash desk №1 TR" 
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Cash desk №2" text in the field named "Description_en"
		And I input "Cash desk №2 TR" text in the field named "Description_tr"
		And I click "Ok" button
		Then the form attribute named "Type" became equal to "Cash"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
		Then I check for the "CashAccounts" catalog element with the "Description_en" "Cash desk №2"  
		Then I check for the "CashAccounts" catalog element with the "Description_tr" "Cash desk №2 TR" 
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Cash desk №3" text in the field named "Description_en"
		And I input "Cash desk №3 TR" text in the field named "Description_tr"
		And I click "Ok" button
		Then the form attribute named "Type" became equal to "Cash"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
		Then I check for the "CashAccounts" catalog element with the "Description_en" "Cash desk №3"  
		Then I check for the "CashAccounts" catalog element with the "Description_tr" "Cash desk №3 TR" 
	* Create and check the creation of bank account: Bank account TRY, Bank account USD, Bank account EUR
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Bank account, TRY" text in the field named "Description_en"
		And I input "Bank account, TRY TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I change the radio button named "Type" value to "Bank"
		And I input "112000000018" text in "Number" field
		And I input "OTP" text in "Bank name" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| Code | Description  |
			| TRY  | Turkish lira |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
		Then I check for the "CashAccounts" catalog element with the "Description_en" "Bank account, TRY"  
		Then I check for the "CashAccounts" catalog element with the "Description_tr" "Bank account, TRY TR" 
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Bank account, USD" text in the field named "Description_en"
		And I input "Bank account, USD TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I change the radio button named "Type" value to "Bank"
		And I input "112000000019" text in "Number" field
		And I input "OTP" text in "Bank name" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| Code | Description     |
			| USD  | American dollar |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
		Then I check for the "CashAccounts" catalog element with the "Description_en" "Bank account, USD"  
		Then I check for the "CashAccounts" catalog element with the "Description_tr" "Bank account, USD TR" 
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Bank account, EUR" text in the field named "Description_en"
		And I input "Bank account, EUR TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I change the radio button named "Type" value to "Bank"
		And I input "112000000020" text in "Number" field
		And I input "OTP" text in "Bank name" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| Code | Description |
			| EUR  | Euro        |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
		Then I check for the "CashAccounts" catalog element with the "Description_en" "Bank account, EUR"  
		Then I check for the "CashAccounts" catalog element with the "Description_tr" "Bank account, EUR TR"
	* Create Transit bank account
		* Create Transit Main
			And I click the button named "FormCreate"
			And I click Open button of the field named "Description_en"
			And I input "Transit Main" text in the field named "Description_en"
			And I input "Transit Main" text in the field named "Description_tr"
			And I click "Ok" button
			And I change the radio button named "Type" value to "Transit"
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"
			And Delay 5
			Then I check for the "CashAccounts" catalog element with the "Description_en" "Transit Main"
		* Create Transit Second
			And I click the button named "FormCreate"
			And I click Open button of the field named "Description_en"
			And I input "Transit Second" text in the field named "Description_en"
			And I input "Transit Second" text in the field named "Description_tr"
			And I click "Ok" button
			And I change the radio button named "Type" value to "Transit"
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"
			And Delay 5
			Then I check for the "CashAccounts" catalog element with the "Description_en" "Transit Second"
	* Filling Transit account in the Bank account, TRY
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
		And I click Select button of "Transit account" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Transit Main' |
		And I select current line in "List" table
		And I click "Save and close" button
	* Filling Transit account in the Bank account, USD
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, USD' |
		And I select current line in "List" table
		And I click Select button of "Transit account" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Transit Second' |
		And I select current line in "List" table
		And I click "Save and close" button


Scenario: _005022 filling in the "Partners" catalog
	* Opening the form for filling in Partners
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And Delay 2
	* Create partners: Ferron BP, Kalipso, Manager B, Lomaniti
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Ferron BP" text in the field named "Description_en"
		And I input "Ferron BP TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Customer"
		And I set checkbox named "Vendor"
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Kalipso" text in the field named "Description_en"
		And I input "Kalipso TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Customer"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Manager B" text in the field named "Description_en"
		And I input "Manager B TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Customer"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Lomaniti" text in the field named "Description_en"
		And I input "Lomaniti TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Customer"
		And I click the button named "FormWriteAndClose"
	* Check for created partners
		Then I check for the "Partners" catalog element with the "Description_en" "Ferron BP"  
		Then I check for the "Partners" catalog element with the "Description_tr" "Ferron BP TR"
		Then I check for the "Partners" catalog element with the "Description_en" "Kalipso"
		Then I check for the "Partners" catalog element with the "Description_en" "Manager B"
		And Delay 2
		Then I check for the "Partners" catalog element with the "Description_en" "Lomaniti"

Scenario: _005023 filling in the "Partner segments content" catalog
	* Opening the form for filling in Partner segments content
		Given I open hyperlink "e1cib/list/Catalog.PartnerSegments"
		And Delay 2
	* Create segments: Retail, Dealer
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Retail" text in the field named "Description_en"
		And I input "Retail TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Dealer" text in the field named "Description_en"
		And I input "Dealer TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 2
	* Check for created Partner segments content
		Then I check for the "PartnerSegments" catalog element with the "Description_en" "Dealer"  
		Then I check for the "PartnerSegments" catalog element with the "Description_tr" "Dealer TR"
		Then I check for the "PartnerSegments" catalog element with the "Description_tr" "Retail TR"
		Then I check for the "PartnerSegments" catalog element with the "Description_en" "Retail" 

Scenario: _005024 filling in the "Payment terms" catalog 
	* Opening a form and creating Payment terms
		Given I open hyperlink "e1cib/list/Catalog.PaymentSchedules"
		When create a catalog element with the name Test
	* Check for created Payment terms
		Then I check for the "PaymentSchedules" catalog element with the "Description_en" "Test ENG"  
		Then I check for the "PaymentSchedules" catalog element with the "Description_tr" "Test TR"


Scenario: _005026 filling in the "Item segments content" catalog 
	* Opening a form and creating Item segments content
		Given I open hyperlink "e1cib/list/Catalog.ItemSegments"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Sale autum" text in the field named "Description_en"
		And I input "Sale autum TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 2
	* Check creation Item segments content
		Then I check for the "ItemSegments" catalog element with the "Description_en" "Sale autum"
		Then I check for the "ItemSegments" catalog element with the "Description_tr" "Sale autum TR"



Scenario: _005027 filling in the "Payment types" catalog  
	* Opening a form and creating Payment types
		Given I open hyperlink "e1cib/list/Catalog.PaymentTypes"
		When create a catalog element with the name Test
		And I close current window
	* Check for created Payment types
		Then I check for the "PaymentTypes" catalog element with the "Description_en" "Test ENG"  
		Then I check for the "PaymentTypes" catalog element with the "Description_tr" "Test TR"



Scenario: _005028 filling in the "Price types" catalog  
	* Opening a form and creating customer prices Basic Price Types, Price USD, Discount Price TRY 1, Discount Price TRY 2, Basic Price without VAT, Discount 1 TRY without VAT, Discount 2 TRY without VAT
		Given I open hyperlink "e1cib/list/Catalog.PriceTypes"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Basic Price Types" text in the field named "Description_en"
		And I input "Basic Price Types TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Price USD" text in the field named "Description_en"
		And I input "Price USD TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| USD  |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Discount Price TRY 1" text in the field named "Description_en"
		And I input "Discount Price TRY 1 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Discount Price TRY 2" text in the field named "Description_en"
		And I input "Discount Price TRY 2 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Basic Price without VAT" text in the field named "Description_en"
		And I input "Basic Price without VAT" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Discount 1 TRY without VAT" text in the field named "Description_en"
		And I input "Discount 1 TRY without VAT" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Discount 2 TRY without VAT" text in the field named "Description_en"
		And I input "Discount 2 TRY without VAT" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
	* Creating price types for vendors: Vendor price, TRY, Vendor price, USD, Vendor price, EUR
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Vendor price, TRY" text in the field named "Description_en"
		And I input "Vendor price, TRY TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Vendor price, USD" text in the field named "Description_en"
		And I input "Vendor price, USD TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| USD  |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Vendor price, EUR" text in the field named "Description_en"
		And I input "Vendor price, EUR TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| EUR  |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
	* Check for created price types
		Then I check for the "PriceTypes" catalog element with the "Description_en" "Vendor price, TRY"
		Then I check for the "PriceTypes" catalog element with the "Description_en" "Vendor price, USD"
		And Delay 2
		Then I check for the "PriceTypes" catalog element with the "Description_en" "Vendor price, EUR"
		And Delay 2
		Then I check for the "PriceTypes" catalog element with the "Description_en" "Basic Price Types"
		Then I check for the "PriceTypes" catalog element with the "Description_tr" "Basic Price Types TR"
		And Delay 2
		Then I check for the "PriceTypes" catalog element with the "Description_en" "Price USD"
		And Delay 2
		Then I check for the "PriceTypes" catalog element with the "Description_en" "Discount Price TRY 1"
		Then I check for the "PriceTypes" catalog element with the "Description_en" "Discount Price TRY 2"
		And Delay 2
		Then I check for the "PriceTypes" catalog element with the "Description_en" "Basic Price without VAT"
		And Delay 2
		Then I check for the "PriceTypes" catalog element with the "Description_en" "Discount 1 TRY without VAT"
		Then I check for the "PriceTypes" catalog element with the "Description_en" "Discount 2 TRY without VAT"



Scenario: _005031 filling in the "Special offers" catalog
	* Opening a form and creating Special offers: Special Price
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Special Price" text in the field named "Description_en"
		And I input "Special Price TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Special offer type" field
		And I click the button named "FormCreate"
		And I click Select button of "Plugins" field
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Special Price" text in the field named "Description_en"
		And I input "Special Price" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "Special Price" text in the field named "Name"
		And I click the button named "FormWriteAndClose"
		And I wait "Plugins (create)" window closing in 20 seconds
		And I click the button named "FormChoose"
		And I click Open button of the field named "Description_en"
		And I input "Special Price" text in the field named "Description_en"
		And I input "Special Price" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 2
		And I click the button named "FormChoose"
		And I input "2" text in the field named "Priority"
		And I input "03.12.2018  0:00:00" text in the field named "StartOf"
		And I input "05.12.2018  0:00:00" text in the field named "EndOf"
		And I select "Sales" exact value from "Document type" drop-down list
		And I set checkbox named "Manually"
		And I set checkbox named "Launch"
		And I click the button named "FormWriteAndClose"
		And Delay 2
	* Check creation
		Then I check for the "SpecialOffers" catalog element with the "Description_en" "Special Price"  
		Then I check for the "SpecialOffers" catalog element with the "Description_tr" "Special Price TR"


Scenario: _005032 filling in the "Stores" catalog
	* Opening a form for creating Stores
		Given I open hyperlink "e1cib/list/Catalog.Stores"
		And Delay 2
	* Create Store 01
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Store 01" text in the field named "Description_en"
		And I input "Store 01 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create Store 02
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Store 02" text in the field named "Description_en"
		And I input "Store 02 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "UseGoodsReceipt"
		And I set checkbox named "UseShipmentConfirmation"
		Then the form attribute named "Transit" became equal to "No"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create Store 03
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Store 03" text in the field named "Description_en"
		And I input "Store 03 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "UseGoodsReceipt"
		And I set checkbox named "UseShipmentConfirmation"
		Then the form attribute named "Transit" became equal to "No"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create Store 04
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Store 04" text in the field named "Description_en"
		And I input "Store 04 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Check creation "Stores"
		Then I check for the "Stores" catalog element with the "Description_en" "Store 01"  
		Then I check for the "Stores" catalog element with the "Description_tr" "Store 01 TR"
		Then I check for the "Stores" catalog element with the "Description_en" "Store 02"  
		Then I check for the "Stores" catalog element with the "Description_en" "Store 03"
		Then I check for the "Stores" catalog element with the "Description_en" "Store 04"

Scenario: _005033 filling in the "Tax rates" catalog  
	* Opening a form for creating Tax rates
		Given I open hyperlink "e1cib/list/Catalog.TaxRates"
		And Delay 2
	* Create tax rate '8%'
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "8%" text in the field named "Description_en"
		And I input "8% TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "8,000000000000" text in the field named "Rate"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create tax rate '18%'
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "18%" text in the field named "Description_en"
		And I input "18% TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "18,000000000000" text in "Rate" field
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create tax rate 'Without VAT'
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Without VAT" text in the field named "Description_en"
		And I input "Without VAT TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "0,000000000000" text in the field named "Rate"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create tax rate '0%'
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "0%" text in the field named "Description_en"
		And I input "0%" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "0,000000000000" text in the field named "Rate"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create tax rate '1%'
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "1%" text in the field named "Description_en"
		And I input "1%" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "1,000000000000" text in the field named "Rate"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Check creation tax rates
		Then I check for the "TaxRates" catalog element with the "Description_en" "8%"  
		Then I check for the "TaxRates" catalog element with the "Description_tr" "8% TR"
		Then I check for the "TaxRates" catalog element with the "Description_en" "Without VAT"  
		Then I check for the "TaxRates" catalog element with the "Description_en" "18%"
		Then I check for the "TaxRates" catalog element with the "Description_en" "1%"



Scenario: _005039 filling in the status catalog for Inventory transfer order
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element InventoryTransferOrder
		And I expand a line in "List" table
			| 'Description'    |
			| 'Objects status history' |
		And I go to line in "List" table
			| Predefined data item name |
			| InventoryTransferOrder                |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Inventory transfer order" text in the field named "Description_en"
		And I input "Inventory transfer order TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Inventory transfer order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in the field named "Description_en"
		And I input "Wait TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Inventory transfer order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in the field named "Description_en"
		And I input "Approved TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Send"
		And I go to line in "List" table
		| 'Description'              |
		| 'Inventory transfer order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Send" text in the field named "Description_en"
		And I input "Send TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Receive"
		And I go to line in "List" table
		| 'Description'              |
		| 'Inventory transfer order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Receive" text in the field named "Description_en"
		And I input "Receive TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And I close current window

Scenario: _005040 filling in the status catalog for Outgoing Payment Order
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element OutgoingPaymentOrder
		And I expand a line in "List" table
			| 'Description'    |
			| 'Objects status history' |
		And I go to line in "List" table
			| Predefined data item name |
			| OutgoingPaymentOrder                |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Outgoing payment order" text in the field named "Description_en"
		And I input "Outgoing payment order TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Outgoing payment order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in the field named "Description_en"
		And I input "Wait TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Outgoing payment order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in the field named "Description_en"
		And I input "Approved TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button

Scenario: _005041 filling in the status catalog for Purchase return order
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element  PurchaseReturnOrder
		And I expand a line in "List" table
			| 'Description'    |
			| 'Objects status history' |
		And I go to line in "List" table
			| Predefined data item name |
			| PurchaseReturnOrder                |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Purchase return order" text in the field named "Description_en"
		And I input "Purchase return order TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Purchase return order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in the field named "Description_en"
		And I input "Wait TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Purchase return order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in the field named "Description_en"
		And I input "Approved TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button


Scenario: _005042 filling in the status catalog for Purchase order
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element PurchaseOrder
		And I expand a line in "List" table
			| 'Description'    |
			| 'Objects status history' |
		And I go to line in "List" table
			| Predefined data item name |
			| PurchaseOrder                |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Purchase order" text in the field named "Description_en"
		And I input "Purchase order TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Purchase order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in the field named "Description_en"
		And I input "Wait TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Purchase order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in the field named "Description_en"
		And I input "Approved TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button

Scenario: _005043 filling in the status catalog for Sales return order
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element  SalesReturnOrder
		And I expand a line in "List" table
			| 'Description'    |
			| 'Objects status history' |
		And I go to line in "List" table
			| Predefined data item name |
			| SalesReturnOrder                |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Sales return order" text in the field named "Description_en"
		And I input "Sales return order TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Sales return order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in the field named "Description_en"
		And I input "Wait TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Sales return order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in the field named "Description_en"
		And I input "Approved TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button

Scenario: _005044 filling in the status catalog for Sales order
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element  SalesOrder
		And I expand a line in "List" table
			| 'Description'    |
			| 'Objects status history' |
		And I go to line in "List" table
			| Predefined data item name |
			| SalesOrder                |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Sales order" text in the field named "Description_en"
		And I input "Sales order TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Sales order' |
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in the field named "Description_en"
		And I input "Wait TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Sales order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in the field named "Description_en"
		And I input "Approved TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Done"
		And I go to line in "List" table
		| 'Description'              |
		| 'Sales order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Done" text in the field named "Description_en"
		And I input "Done TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	And I close all client application windows

Scenario: _005045 check for clearing the UniqueID field when copying the status
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
		And I expand a line in "List" table
			| 'Description'    |
			| 'Objects status history' |
	* Copy status
		And I expand a line in "List" table
			| 'Description' | 'Predefined data item name' |
			| 'Sales order' | 'SalesOrder'                |
		And I go to line in "List" table
			| 'Description' |
			| 'Wait'        |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check UniqueID field deleting
		Then the form attribute named "UniqueID" became equal to ""
		Then the form attribute named "Description_en" became equal to "Wait"
	And I close all client application windows



Scenario: _005046 filling in Business units
	* Open a creation form Business units
		Given I open hyperlink "e1cib/list/Catalog.BusinessUnits"
	* Create business unit 'Front office'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Front office" text in the field named "Description_en"
		And I input "Front office TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Create business unit 'Accountants office'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Accountants office" text in the field named "Description_en"
		And I input "Accountants office TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Create business unit 'Distribution department'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Distribution department" text in the field named "Description_en"
		And I input "Distribution department TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Create business unit 'Logistics department'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Logistics department" text in the field named "Description_en"
		And I input "Logistics department TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Check creation Business units
		Then I check for the "BusinessUnits" catalog element with the "Description_en" "Front office"
		Then I check for the "BusinessUnits" catalog element with the "Description_en" "Accountants office"
		And Delay 2
		Then I check for the "BusinessUnits" catalog element with the "Description_en" "Distribution department"
		And Delay 2
		Then I check for the "BusinessUnits" catalog element with the "Description_en" "Logistics department"

Scenario: _005047 filling in Expense type
	* Open a creation form Expense type
		Given I open hyperlink "e1cib/list/Catalog.ExpenseAndRevenueTypes"
	* Create expense type 'Rent'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Rent" text in the field named "Description_en"
		And I input "Rent TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Create expense type  'Telephone communications'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Telephone communications" text in the field named "Description_en"
		And I input "Telephone communications TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Create expense type 'Fuel'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Fuel" text in the field named "Description_en"
		And I input "Fuel TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Create expense type  'Software'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Software" text in the field named "Description_en"
		And I input "Software TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Create expense type  'Delivery'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Delivery" text in the field named "Description_en"
		And I input "Delivery TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Check creation Expense type
		Then I check for the "ExpenseAndRevenueTypes" catalog element with the "Description_en" "Rent"
		Then I check for the "ExpenseAndRevenueTypes" catalog element with the "Description_en" "Telephone communications"
		Then I check for the "ExpenseAndRevenueTypes" catalog element with the "Description_en" "Fuel"
		And Delay 2
		Then I check for the "ExpenseAndRevenueTypes" catalog element with the "Description_en" "Software"
		And Delay 2
		Then I check for the "ExpenseAndRevenueTypes" catalog element with the "Description_en" "Delivery"

Scenario: _005048 filling in the "Item segments content" catalog  "Tax additional analytics"
	* Open and filling in Tax additional analytics
		Given I open hyperlink "e1cib/list/Catalog.TaxAnalytics"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Analytics 01" text in the field named "Description_en"
		And I input "Analytics 01 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And I close all client application windows
		And Delay 2
	* Check for created  Tax additional analytics
		Then I check for the "TaxAnalytics" catalog element with the "Description_en" "Analytics 01"  
		Then I check for the "TaxAnalytics" catalog element with the "Description_tr" "Analytics 01 TR"

