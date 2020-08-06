#language: en
@tree
@Positive
@Test


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
	* Open Country creation form
		Given I open hyperlink "e1cib/list/Catalog.Countries"
		And I click the button named "FormCreate"
	* Data Filling - Turkey
		And I click Open button of the field named "Description_en"
		And I input "Turkey" text in "ENG" field
		And I input "Turkey TR" text in "TR" field
		And I input "Турция" text in "RU" field
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
	* Data Filling - Ukraine
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Ukraine" text in the field named "Description_en"
		And I input "Ukraine TR" text in the field named "Description_tr"
		And I input "Украина" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Check for added countries in the catalog
		Then I check for the "Countries" catalog element with the "Description_en" "Turkey"
		Then I check for the "Countries" catalog element with the "Description_tr" "Turkey TR"
		Then I check for the "Countries" catalog element with the "Description_ru" "Турция"
		Then I check for the "Countries" catalog element with the "Description_en" "Ukraine"
		Then I check for the "Countries" catalog element with the "Description_tr" "Ukraine TR"
		Then I check for the "Countries" catalog element with the "Description_ru" "Украина"




Scenario: _005011 filling in the "Currencies" catalog
	* Open Currency creation form
		Given I open hyperlink "e1cib/list/Catalog.Currencies"
		And I click the button named "FormCreate"
	* Create American dollar
		And I click Open button of the field named "Description_en"
		And I input "American dollar" text in the field named "Description_en"
		And I input "American dollar TR" text in the field named "Description_tr"
		And I input "Американский доллар" text in the field named "Description_ru"
		And I click "Ok" button
		And I input "$" text in "Symbol" field
		And I input "USD" text in "Code" field
		And I input "840" text in "Numeric code" field
		And I click the button named "FormWriteAndClose"
	* Create Euro
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Euro" text in the field named "Description_en"
		And I input "Euro TR" text in the field named "Description_tr"
		And I input "Евро" text in the field named "Description_ru"
		And I click "Ok" button
		And I input "€" text in "Symbol" field
		And I input "EUR" text in "Code" field
		And I input "947" text in "Numeric code" field
		And I click the button named "FormWrite"
	* Check data save
		Then the form attribute named "Code" became equal to "EUR"
		Then the form attribute named "Symbol" became equal to "€"
		Then the form attribute named "NumericCode" became equal to "947"
		Then the form attribute named "Description_en" became equal to "Euro"
		And I click the button named "FormWriteAndClose"
	* Check for added currencies in the catalog
		Then I check for the "Currencies" catalog element with the "Description_en" "American dollar"
		Then I check for the "Currencies" catalog element with the "Description_tr" "American dollar TR"
		Then I check for the "Currencies" catalog element with the "Description_ru" "Американский доллар"
		Then I check for the "Currencies" catalog element with the "Description_en" "Euro"
		Then I check for the "Currencies" catalog element with the "Description_tr" "Euro TR"
		Then I check for the "Currencies" catalog element with the "Description_ru" "Евро"



Scenario: _005012 filling in the "Integration settings" catalog
	* Create setting with integration type local file storage
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "LOCAL STORAGE" text in "Description" field
		And I select "Local file storage" exact value from "Integration type" drop-down list
		And in the table "ConnectionSetting" I click the button named "ConnectionSettingFillByDefault"
		And I go to line in "ConnectionSetting" table
			| 'Key'         |
			| 'AddressPath' |
		And I activate "Value" field in "ConnectionSetting" table
		And I select current line in "ConnectionSetting" table
		And I input "#workingDir#\DataProcessor\Picture\Source" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key'       | 'Value' |
			| 'QueryType' | 'POST'  |
		And I activate "Key" field in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I click "Save and close" button
	* Create setting with integration type file storage
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "FILE STORAGE" text in "Description" field
		And I select "File storage" exact value from "Integration type" drop-down list
		And in the table "ConnectionSetting" I click the button named "ConnectionSettingFillByDefault"
		And I activate "Value" field in "ConnectionSetting" table
		And I input "GET" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key'             |
			| 'ResourceAddress' |
		And I select current line in "ConnectionSetting" table
		And I input "/hs/filetransfer" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key' | 'Value'     |
			| 'Ip'  | 'localhost' |
		And I select current line in "ConnectionSetting" table
		And I input "localhost" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key'  | 'Value' |
			| 'Port' | '8 080' |
		And I select current line in "ConnectionSetting" table
		And I input "8 080" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key'  |
			| 'User' |
		And I select current line in "ConnectionSetting" table
		And I input "Admin" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key'      |
			| 'Password' |
		And I select current line in "ConnectionSetting" table
		And I input "123" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key'              |
			| 'SecureConnection' |
		And I select current line in "ConnectionSetting" table
		And I click choice button of "Value" attribute in "ConnectionSetting" table
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''        |
			| 'Boolean' |
		And I select current line in "" table
		Then "Integration setting (create) *" window is opened
		And I select "Yes" exact value from "Value" drop-down list in "ConnectionSetting" table
		And I click "Save" button
		Then the form attribute named "Description" became equal to "FILE STORAGE"
		And I wait the field named "UniqueID" will be filled in "10" seconds
		Then the form attribute named "IntegrationType" became equal to "File storage"
		And "ConnectionSetting" table became equal
			| '#'  | 'Key'                 | 'Value'            |
			| '1'  | 'QueryType'           | 'GET'              |
			| '2'  | 'ResourceAddress'     | '/hs/filetransfer' |
			| '3'  | 'Ip'                  | 'localhost'        |
			| '4'  | 'Port'                | '8 080'            |
			| '5'  | 'User'                | 'Admin'            |
			| '6'  | 'Password'            | '123'              |
			| '7'  | 'Proxy'               | ''                 |
			| '8'  | 'TimeOut'             | '60'               |
			| '9'  | 'SecureConnection'    | 'Yes'              |
			| '10' | 'UseOSAuthentication' | 'No'               |
			| '11' | 'Headers'             | 'Map'              |
		Then the form attribute named "ExternalDataProc" became equal to ""
		And I click "Save and close" button
	* Create setting with integration type Google drive (without connection)
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "Google drive" text in "Description" field
		And I select "Google drive" exact value from "Integration type" drop-down list
		And I click "Save and close" button
	* Create setting with integration type Other (without connection)
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "Other" text in "Description" field
		And I select "Other" exact value from "Integration type" drop-down list
		And I click "Save and close" button
	* Create setting to download the course (bank.gov.ua)
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "Bank UA" text in "Description" field
		And I click "Save" button
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description'    |
			| 'ExternalBankUa' |
		And I select current line in "List" table
		And I click "Save and close" button
	* Check data save
		And "List" table contains lines
			| 'Description'     |
			| 'Bank UA'         |
			| 'FILE STORAGE'    |
			| 'Google drive'    |
			| 'LOCAL STORAGE'   |
			| 'Other'           |
		And I close all client application windows
		


Scenario: _005013 filling in the "Companies" catalog
	* Preparation
		And I close all client application windows
		When Create catalog IntegrationSettings objects (currency source)
		When Create catalog Currencies objects
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I go to line in "List" table
			| 'Description'  |
			| 'Forex Buying' |
		And I select current line in "List" table
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'  |
			| 'Forex Seling' |
		And I select current line in "List" table
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description' |
			| 'Bank UA'     |
		And I select current line in "List" table
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click "Save and close" button
	* Opening the form for filling in
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I click the button named "FormCreate"
	* Create Own company
		* Filling in company information
			And I click Open button of the field named "Description_en"
			And I input "Main Company" text in the field named "Description_en"
			And I input "Main Company TR" text in the field named "Description_tr"
			And I input "Главная компания" text in the field named "Description_ru"
			And I click "Ok" button
			And I input "Turkey" text in the field named "Country"
			And I set checkbox "Our"
			And I select "Company" exact value from the drop-down list named "Type"
			And I click "Save" button
		* Filling in currency information (Local currency, Reporting currency, Budgeting currency)
			And I move to "Currencies" tab
			* Creation and addition of Local currency
				And in the table "Currencies" I click the button named "CurrenciesAdd"
				And I click choice button of "Movement type" attribute in "Currencies" table
				And I click the button named "FormCreate"
				And I input "Local currency" text in "ENG" field
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
				And I input "Reporting currency" text in "ENG" field
				And I click "Save and close" button
				And I click the button named "FormChoose"
			* Creation and addition of Budgeting currency
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
				And I select "Budgeting" exact value from "Type" drop-down list
				And I input "Budgeting currency" text in "ENG" field
				And I set checkbox "Deferred calculation"
				And I click "Save and close" button
				And I click the button named "FormChoose"
				And I finish line editing in "Currencies" table
			And I click "Save and close" button
			And Delay 5
		* Check the availability of the created company in the catalog
			Then I check for the "Companies" catalog element with the "Description_en" "Main Company" 
			Then I check for the "Companies" catalog element with the "Description_tr" "Main Company TR"
			Then I check for the "Companies" catalog element with the "Description_ru" "Главная компания"


Scenario: _005017 creation Movement Type for Partner term currencies
	* Preparation
		When Create catalog Currencies objects
		When Create catalog IntegrationSettings objects (currency source)
	* Opening charts of characteristic types - Currency movement
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.CurrencyMovementType"
	* Create currency for Partner terms - TRY
		And I click the button named "FormCreate"
		And I input "TRY" text in "ENG" field
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
	* Check data save
		And "List" table contains lines
		| 'Description'           | 'Type'         | 'Currency' | 'Reference'                | 'Source'       | 'Deferred calculation' |
		| 'TRY'                   | 'Partner term' | 'TRY'      | 'TRY'                      | 'Forex Seling' | 'No'                   |
		

Scenario: _005014 filling in the "Units" catalog
	* Opening the form for filling in "Units"
		Given I open hyperlink "e1cib/list/Catalog.Units"
		And I click the button named "FormCreate"
	* Creating a unit of measurement 'pcs'
		And I click Open button of the field named "Description_en"
		And I input "pcs" text in the field named "Description_en"
		And I input "adet" text in the field named "Description_tr"
		And I input "шт" text in the field named "Description_ru"
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
	* Check for created elements
		Then I check for the "Units" catalog element with the "Description_en" "pcs"  
		Then I check for the "Units" catalog element with the "Description_tr" "adet"
		Then I check for the "Units" catalog element with the "Description_ru" "шт"
		Then I check for the "Units" catalog element with the "Description_en" "box (4 pcs)"


Scenario: _005015 filling in the "AccessGroups" catalog
	* Opening the form for filling in AccessGroups
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
		And I click the button named "FormCreate"
	* Data Filling - Admin
		And I click Open button of the field named "Description_en"
		And I input "Admin" text in the field named "Description_en"
		And I input "Admin TR" text in the field named "Description_tr"
		And I input "Админ" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Access group creation "Manager"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Manager" text in the field named "Description_en"
		And I input "Manager TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
	* Check for created AccessGroups
		Then I check for the "AccessGroups" catalog element with the "Description_en" "Admin"
		Then I check for the "AccessGroups" catalog element with the "Description_tr" "Admin TR"
		Then I check for the "AccessGroups" catalog element with the "Description_ru" "Админ"
		Then I check for the "AccessGroups" catalog element with the "Description_en" "Manager"

Scenario: _005016 filling in the "AccessProfiles" catalog
	* Opening the form for filling in AccessProfiles
		Given I open hyperlink "e1cib/list/Catalog.AccessProfiles"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
	* Data Filling - management
		And I click Open button of the field named "Description_en"
		And I input "Management" text in the field named "Description_en"
		And I input "Management TR" text in the field named "Description_tr"
		And I input "Руководство" text in the field named "Description_ru"
		And I click "Ok" button
		And in the table "Roles" I click "Update roles" button
		* Set up access for admin
			And in the table "Roles" I click "Update roles" button
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation' | 'Use' |
				| 'IRP'           | 'Full access'  | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'     | 'Use' |
				| 'IRP'           | 'Run thick client' | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'    | 'Use' |
				| 'IRP'           | 'Run thin client' | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'   | 'Use' |
				| 'IRP'           | 'Run web client' | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'      | 'Use' |
				| 'IRP'           | 'Run mobile client' | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation' | 'Use' |
				| 'IRP'           | 'Basic role'   | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I click the button named "FormWriteAndClose"
			And I wait "User access profiles (create)" window closing in 20 seconds
	* Data Filling - Logistic team
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Logistic team" text in the field named "Description_en"
		And I input "Logistic team TR" text in the field named "Description_tr"
		And I click "Ok" button
		And in the table "Roles" I click "Update roles" button
		* Set up access for the Logistic team
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'    | 'Use' |
				| 'IRP'           | 'Run thin client' | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'   | 'Use' |
				| 'IRP'           | 'Run web client' | 'No'  |
			And I change "Use" checkbox in "Roles" table
		And I click the button named "FormWriteAndClose"
	* Check for created User access profiles
		Then I check for the "AccessProfiles" catalog element with the "Description_en" "Management"  
		Then I check for the "AccessProfiles" catalog element with the "Description_tr" "Management TR"
		Then I check for the "AccessProfiles" catalog element with the "Description_ru" "Руководство"


Scenario: _005018 filling in the "Cash/Bank accounts" catalog
	* Preparation
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
	* Opening the form for filling in Accounts
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And Delay 2
		And I click the button named "FormCreate"
	* Create and check the creation of Cash account: Cash desk №1 (with fix currency), Cash desk №2 (multi currency)
		And I click Open button of the field named "Description_en"
		And I input "Cash desk №1" text in the field named "Description_en"
		And I input "Cash desk №1 TR" text in the field named "Description_tr"
		And I input "Касса №1" text in the field named "Description_ru"
		And I click "Ok" button
		Then the form attribute named "Type" became equal to "Cash"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I change the radio button named "CurrencyType" value to "Fixed"
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Type" became equal to "Cash"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the form attribute named "Number" became equal to ""
			Then the form attribute named "BankName" became equal to ""
			Then the form attribute named "TransitAccount" became equal to ""
			Then the form attribute named "Description_en" became equal to "Cash desk №1"
			Then the form attribute named "CurrencyType" became equal to "Fixed"
			Then the form attribute named "Currency" became equal to "USD"
		And I click the button named "FormWriteAndClose"
		And Delay 5
		Then I check for the "CashAccounts" catalog element with the "Description_en" "Cash desk №1"  
		Then I check for the "CashAccounts" catalog element with the "Description_tr" "Cash desk №1 TR" 
		Then I check for the "CashAccounts" catalog element with the "Description_ru" "Касса №1" 
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
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Type" became equal to "Cash"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the form attribute named "Number" became equal to ""
			Then the form attribute named "BankName" became equal to ""
			Then the form attribute named "TransitAccount" became equal to ""
			Then the form attribute named "Description_en" became equal to "Cash desk №2"
			Then the form attribute named "CurrencyType" became equal to "Multi"
			Then the form attribute named "Currency" became equal to ""
		And I click the button named "FormWriteAndClose"
		And Delay 5
		Then I check for the "CashAccounts" catalog element with the "Description_en" "Cash desk №2"  
		Then I check for the "CashAccounts" catalog element with the "Description_tr" "Cash desk №2 TR" 
	* Create and check the creation of bank account: Bank account TRY
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Bank account, TRY" text in the field named "Description_en"
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
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Type" became equal to "Bank"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the form attribute named "Number" became equal to "112000000018"
			Then the form attribute named "BankName" became equal to "OTP"
			Then the form attribute named "Description_en" became equal to "Bank account, TRY"
			Then the form attribute named "CurrencyType" became equal to "Fixed"
			Then the form attribute named "Currency" became equal to "TRY"
		And I click the button named "FormWriteAndClose"
		And Delay 5
		Then I check for the "CashAccounts" catalog element with the "Description_en" "Bank account, TRY"  
	* Create Transit bank account
		* Create Transit Main
			And I click the button named "FormCreate"
			And I click Open button of the field named "Description_en"
			And I input "Transit Main" text in the field named "Description_en"
			And I click "Ok" button
			And I change the radio button named "Type" value to "Transit"
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click the button named "FormWrite"
			* Check data save	
				Then the form attribute named "Type" became equal to "Transit"
				Then the form attribute named "Company" became equal to "Main Company"
				Then the form attribute named "Number" became equal to ""
				Then the form attribute named "BankName" became equal to ""
				Then the form attribute named "TransitAccount" became equal to ""
				Then the form attribute named "Description_en" became equal to "Transit Main"
				Then the form attribute named "CurrencyType" became equal to "Multi"
				Then the form attribute named "Currency" became equal to ""
			And I click the button named "FormWriteAndClose"
			And Delay 5
			Then I check for the "CashAccounts" catalog element with the "Description_en" "Transit Main"
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
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "TransitAccount" became equal to "Transit Main"
			And I click the button named "FormWriteAndClose"

Scenario: _005022 filling in the "Partners" catalog
	* Opening the form for filling in Partners
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And Delay 2
	* Create partners: Ferron BP (customer and vendor), Kalipso (customer), Manager B (Employee), Lomaniti(vendor)
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Ferron BP" text in the field named "Description_en"
		And I input "Ferron BP TR" text in the field named "Description_tr"
		And I input "Феррон BP" text in the field named "Description_ru"
		And I click "Ok" button
		And I set checkbox named "Customer"
		And I set checkbox named "Vendor"
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Ferron BP"
			Then the form attribute named "Customer" became equal to "Yes"
			Then the form attribute named "Vendor" became equal to "Yes"
			Then the form attribute named "Employee" became equal to "No"
			Then the form attribute named "Opponent" became equal to "No"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Kalipso" text in the field named "Description_en"
		And I input "Kalipso TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Customer"
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Kalipso"
			Then the form attribute named "Customer" became equal to "Yes"
			Then the form attribute named "Vendor" became equal to "No"
			Then the form attribute named "Employee" became equal to "No"
			Then the form attribute named "Opponent" became equal to "No"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Manager B" text in the field named "Description_en"
		And I input "Manager B TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Employee"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Manager B"
			Then the form attribute named "Customer" became equal to "No"
			Then the form attribute named "Vendor" became equal to "No"
			Then the form attribute named "Employee" became equal to "Yes"
			Then the form attribute named "Opponent" became equal to "No"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Lomaniti" text in the field named "Description_en"
		And I input "Lomaniti TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Vendor"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Lomaniti"
			Then the form attribute named "Customer" became equal to "No"
			Then the form attribute named "Vendor" became equal to "Yes"
			Then the form attribute named "Employee" became equal to "No"
			Then the form attribute named "Opponent" became equal to "No"
		And I click the button named "FormWriteAndClose"
	* Check for created partners
		Then I check for the "Partners" catalog element with the "Description_en" "Ferron BP"  
		Then I check for the "Partners" catalog element with the "Description_tr" "Ferron BP TR"
		Then I check for the "Partners" catalog element with the "Description_ru" "Феррон BP"
		Then I check for the "Partners" catalog element with the "Description_en" "Kalipso"
		Then I check for the "Partners" catalog element with the "Description_en" "Manager B"
		And Delay 2
		Then I check for the "Partners" catalog element with the "Description_en" "Lomaniti"
	* Clear catalog Partners
		And I delete "Partners" catalog element with the Description_en "Ferron BP"
		And I delete "Partners" catalog element with the Description_en "Kalipso"
		And I delete "Partners" catalog element with the Description_en "Manager B"


Scenario: _005023 filling in the "Partner segments content" catalog
	* Opening the form for filling in Partner segments content
		Given I open hyperlink "e1cib/list/Catalog.PartnerSegments"
	* Create segments: Retail
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Distribution" text in the field named "Description_en"
		And I input "Distribution TR" text in the field named "Description_tr"
		And I input "Дистрибьюция" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
	* Check for created Partner segments content
		Then I check for the "PartnerSegments" catalog element with the "Description_tr" "Distribution TR"
		Then I check for the "PartnerSegments" catalog element with the "Description_en" "Distribution" 
		Then I check for the "PartnerSegments" catalog element with the "Description_ru" "Дистрибьюция"

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
		And I input "Осень" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 2
	* Check creation Item segments content
		Then I check for the "ItemSegments" catalog element with the "Description_en" "Sale autum"
		Then I check for the "ItemSegments" catalog element with the "Description_tr" "Sale autum TR"
		Then I check for the "ItemSegments" catalog element with the "Description_ru" "Осень"



Scenario: _005027 filling in the "Payment types" catalog  
	* Opening a form and creating Payment types
		Given I open hyperlink "e1cib/list/Catalog.PaymentTypes"
		When create a catalog element with the name Test
		And I close current window
	* Check for created Payment types
		Then I check for the "PaymentTypes" catalog element with the "Description_en" "Test ENG"  
		Then I check for the "PaymentTypes" catalog element with the "Description_tr" "Test TR"



Scenario: _005028 filling in the "Price types" catalog  
	* Preparation
		When Create catalog Currencies objects
	* Opening a form and creating customer prices Basic Price Types
		Given I open hyperlink "e1cib/list/Catalog.PriceTypes"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Basic Price Types" text in the field named "Description_en"
		And I input "Basic Price Types TR" text in the field named "Description_tr"
		And I input "Базовая цена" text in the field named "Description_ru"
		And I click "Ok" button
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Currency" became equal to "TRY"
			Then the form attribute named "Description_en" became equal to "Basic Price Types"
		And I click the button named "FormWriteAndClose"
	* Check for created price types
		Then I check for the "PriceTypes" catalog element with the "Description_en" "Basic Price Types"
		Then I check for the "PriceTypes" catalog element with the "Description_tr" "Basic Price Types TR"
		Then I check for the "PriceTypes" catalog element with the "Description_ru" "Базовая цена"
		


Scenario: _005031 filling in the "Special offers" catalog
	* Opening a form and creating Special offers: Special Price
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Special Price" text in the field named "Description_en"
		And I input "Special Price TR" text in the field named "Description_tr"
		And I input "Специальная цена" text in the field named "Description_ru"
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
		Then I check for the "SpecialOffers" catalog element with the "Description_ru" "Специальная цена"


Scenario: _005032 filling in the "Stores" catalog
	* Opening a form for creating Stores
		Given I open hyperlink "e1cib/list/Catalog.Stores"
	* Create Store 01
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Store 01" text in the field named "Description_en"
		And I input "Store 01 TR" text in the field named "Description_tr"
		And I input "Склад 01" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "UseGoodsReceipt" became equal to "No"
			Then the form attribute named "UseShipmentConfirmation" became equal to "No"
			Then the form attribute named "Transit" became equal to "No"
			Then the form attribute named "Description_en" became equal to "Store 01"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create Store 02
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Store 02" text in the field named "Description_en"
		And I input "Store 02 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "UseGoodsReceipt"
		And I set checkbox named "UseShipmentConfirmation"
		Then the form attribute named "Transit" became equal to "No"
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "UseGoodsReceipt" became equal to "Yes"
			Then the form attribute named "UseShipmentConfirmation" became equal to "Yes"
			Then the form attribute named "Transit" became equal to "No"
			Then the form attribute named "Description_en" became equal to "Store 02"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create Store 03
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Store 03" text in the field named "Description_en"
		And I input "Store 03 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "UseGoodsReceipt"
		Then the form attribute named "Transit" became equal to "No"
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "UseGoodsReceipt" became equal to "Yes"
			Then the form attribute named "UseShipmentConfirmation" became equal to "No"
			Then the form attribute named "Transit" became equal to "No"
			Then the form attribute named "Description_en" became equal to "Store 03"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create Store 04
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Store 04" text in the field named "Description_en"
		And I input "Store 04 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "UseShipmentConfirmation"
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "UseGoodsReceipt" became equal to "No"
			Then the form attribute named "UseShipmentConfirmation" became equal to "Yes"
			Then the form attribute named "Transit" became equal to "No"
			Then the form attribute named "Description_en" became equal to "Store 04"
		And I click the button named "FormWriteAndClose"
	* Check creation "Stores"
		Then I check for the "Stores" catalog element with the "Description_en" "Store 01"  
		Then I check for the "Stores" catalog element with the "Description_tr" "Store 01 TR"
		Then I check for the "Stores" catalog element with the "Description_ru" "Склад 01"
		Then I check for the "Stores" catalog element with the "Description_en" "Store 02"  
		Then I check for the "Stores" catalog element with the "Description_en" "Store 03"
		Then I check for the "Stores" catalog element with the "Description_en" "Store 04"

Scenario: _005033 filling in the "Tax rates" catalog  
	* Opening a form for creating Tax rates
		Given I open hyperlink "e1cib/list/Catalog.TaxRates"
	* Create tax rate '8%'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "8%" text in the field named "Description_en"
		And I input "8% TR" text in the field named "Description_tr"
		And I input "8% RU" text in the field named "Description_ru"
		And I click "Ok" button
		And I input "8,000000000000" text in the field named "Rate"
		And I click the button named "FormWrite"
		* Check data save
			And the editing text of form attribute named "Rate" became equal to "8,000000000000"
			Then the form attribute named "Description_en" became equal to "8%"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create tax rate 'Without VAT'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Without VAT" text in the field named "Description_en"
		And I input "Without VAT TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "0,000000000000" text in the field named "Rate"
		And I click the button named "FormWrite"
		* Check data save
			And the editing text of form attribute named "Rate" became equal to "0,000000000000"
			Then the form attribute named "Description_en" became equal to "Without VAT"
		And I click the button named "FormWriteAndClose"
	* Create tax rate '0%'
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "0%" text in the field named "Description_en"
		And I input "0%" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "0,000000000000" text in the field named "Rate"
		And I click the button named "FormWrite"
		* Check data save
			And the editing text of form attribute named "Rate" became equal to "0,000000000000"
			Then the form attribute named "Description_en" became equal to "0%"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Check creation tax rates
		Then I check for the "TaxRates" catalog element with the "Description_en" "8%"  
		Then I check for the "TaxRates" catalog element with the "Description_tr" "8% TR"
		Then I check for the "TaxRates" catalog element with the "Description_ru" "8% RU"
		Then I check for the "TaxRates" catalog element with the "Description_en" "Without VAT"  
		Then I check for the "TaxRates" catalog element with the "Description_en" "0%"
	* Clean catalog
		And I delete "TaxRates" catalog element with the Description_en "8%"
		And I delete "TaxRates" catalog element with the Description_en "Without VAT"
		And I delete "TaxRates" catalog element with the Description_en "0%"


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
		And I input "Inventory transfer order" text in "ENG" field
		And I input "Inventory transfer order TR" text in "TR" field
		And I input "Заказ на перемещение товаров" text in "RU" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Inventory transfer order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in "ENG" field
		And I input "Wait TR" text in "TR" field
		And I input "На согласовании" text in "RU" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Inventory transfer order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in "ENG" field
		And I input "Approved TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
	

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
		And I input "Outgoing payment order" text in "ENG" field
		And I input "Outgoing payment order TR" text in "TR" field
		And I input "Заявка на расходование денежных средств" text in "RU" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Outgoing payment order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in "ENG" field
		And I input "Wait TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Outgoing payment order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in "ENG" field
		And I input "Approved TR" text in "TR" field
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
		And I input "Purchase return order" text in "ENG" field
		And I input "Purchase return order TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Purchase return order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in "ENG" field
		And I input "Wait TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Purchase return order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in "ENG" field
		And I input "Approved TR" text in "TR" field
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
		And I input "Purchase order" text in "ENG" field
		And I input "Purchase order TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Purchase order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in "ENG" field
		And I input "Wait TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Purchase order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in "ENG" field
		And I input "Approved TR" text in "TR" field
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
		And I input "Sales return order" text in "ENG" field
		And I input "Sales return order TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Sales return order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in "ENG" field
		And I input "Wait TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Sales return order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in "ENG" field
		And I input "Approved TR" text in "TR" field
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
		And I input "Sales order" text in "ENG" field
		And I input "Sales order TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Sales order' |
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in "ENG" field
		And I input "Wait TR" text in "TR" field
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
		And I input "Approved" text in "ENG" field
		And I input "Approved TR" text in "TR" field
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
		And I input "Front office" text in "ENG" field
		And I input "Front office TR" text in "TR" field
		And I input "Центральный офис" text in "RU" field
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Front office"
		And I click the button named "FormWriteAndClose"
	* Create business unit 'Accountants office'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Accountants office" text in "ENG" field
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Accountants office"
		And I click the button named "FormWriteAndClose"
	* Check creation Business units
		Then I check for the "BusinessUnits" catalog element with the "Description_en" "Front office"
		Then I check for the "BusinessUnits" catalog element with the "Description_tr" "Front office TR"
		Then I check for the "BusinessUnits" catalog element with the "Description_ru" "Центральный офис"
		Then I check for the "BusinessUnits" catalog element with the "Description_en" "Accountants office"

		
Scenario: _005047 filling in Expense type
	* Open a creation form Expense type
		Given I open hyperlink "e1cib/list/Catalog.ExpenseAndRevenueTypes"
	* Create expense type 'Rent'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Rent" text in "ENG" field
		And I input "Rent TR" text in "TR" field
		And I input "Аренда" text in "RU" field
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Rent"
		And I click the button named "FormWriteAndClose"
	* Create expense type  'Delivery'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Delivery" text in "ENG" field
		And I input "Delivery TR" text in "TR" field
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
	* Check creation Expense type
		Then I check for the "ExpenseAndRevenueTypes" catalog element with the "Description_en" "Rent"
		Then I check for the "ExpenseAndRevenueTypes" catalog element with the "Description_tr" "Rent TR"
		Then I check for the "ExpenseAndRevenueTypes" catalog element with the "Description_ru" "Аренда"
		Then I check for the "ExpenseAndRevenueTypes" catalog element with the "Description_en" "Delivery"



Scenario: _005048 filling in the "Item segments content" catalog  "Tax additional analytics"
	* Open and filling in Tax additional analytics
		Given I open hyperlink "e1cib/list/Catalog.TaxAnalytics"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Analytics 01" text in "ENG" field
		And I input "Analytics 01 TR" text in "TR" field
		And I input "Аналитика 01" text in "RU" field
		And I click "Ok" button
		And I click "Save and close" button
		And I close all client application windows
		And Delay 2
	* Check for created  Tax additional analytics
		Then I check for the "TaxAnalytics" catalog element with the "Description_en" "Analytics 01"  
		Then I check for the "TaxAnalytics" catalog element with the "Description_tr" "Analytics 01 TR"
		Then I check for the "TaxAnalytics" catalog element with the "Description_ru" "Аналитика 01"

