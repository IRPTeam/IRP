#language: en
@tree
@Positive
@LoadInfo

Feature: check loading currency from external resources

As a developer
I want to create a processing to download currency rates from external resources.
To upload currency rates to the base


Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"
Tag = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Tag")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Tag"), "#Tag#")}"
webPort = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("webPort")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("webPort"), "#webPort#")}"
isProdMode = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("isProdMode")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("isProdMode"), "#isProdMode#")}"

Background:
	Given I launch TestClient opening script or connect the existing one




Scenario: _020000 preparation (Loadinfo)
	When set True value to the constant
	* Load info
		When Create catalog CashAccounts objects
		When Create catalog PriceTypes objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog IntegrationSettings objects
	* Mocks settings
		If "$isProdMode$" variable is equal to "false" Then
			When import mocks for currency rate
			Given I open hyperlink "e1cib/list/Catalog.DataBaseStatus"
			And I go to line in "List" table
				| 'is Product server'     |
				| 'Yes'                   |
			And I select current line in "List" table
			And I remove checkbox "is Product server"
			And I click "Save and close" button
			And "List" table contains lines
				| 'is Product server'     |
				| 'No'                    |
		* Add Plugin ExternalBankUa
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			And I click the button named "FormCreate"
			And I select external file "$Path$/DataProcessor/bank_gov_ua.epf"
			And I click the button named "FormAddExtDataProc"
			And I input "" text in "Path to plugin for test" field
			And I input "ExternalBankUa" text in "Name" field
			And I click Open button of the field named "Description_en"
			And I input "ExternalBankUa" text in the field named "Description_en"
			And I input "ExternalBankUa" text in the field named "Description_tr"
			And I click "Ok" button
			And I set checkbox "Unsafe mode"
			And I click "Save and close" button
			And I wait "Plugins (create)" window closing in 10 seconds
			Then I check for the "ExternalDataProc" catalog element with the "Description_en" "ExternalBankUa"
		* Add Plugin ExternalTCMBGovTr
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			And I click the button named "FormCreate"
			And I select external file "$Path$/DataProcessor/tcmb_gov_tr.epf"
			And I click the button named "FormAddExtDataProc"
			And I input "" text in "Path to plugin for test" field
			And I input "ExternalTCMBGovTr" text in "Name" field
			And I click Open button of the field named "Description_en"
			And I input "ExternalTCMBGovTr" text in the field named "Description_en"
			And I input "ExternalTCMBGovTr" text in the field named "Description_tr"
			And I click "Ok" button
			And I set checkbox "Unsafe mode"
			And I click "Save and close" button
			And I wait "Plugins (create)" window closing in 10 seconds
			Then I check for the "ExternalDataProc" catalog element with the "Description_en" "ExternalTCMBGovTr"
		* Filling in the setting for currency rate loading from Bank UA
			Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
			And I go to line in "List" table
				| 'Description'     |
				| 'Bank UA'         |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'        |
				| 'ExternalBankUa'     |
			And I select current line in "List" table
			And I click "Settings" button
			Then "Settings" window is opened
			And I click Select button of "Currency from" field
			And I go to line in "List" table
				| 'Description'         |
				| 'Ukraine Hryvnia'     |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "Ok" button
			And I click "Save and close" button
		* Filling in the setting for currency rate loading from tcmb.gov.tr
			And I go to line in "List" table
				| 'Description'      |
				| 'Forex Buying'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'           |
				| 'ExternalTCMBGovTr'     |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "Settings" button
			And I click Select button of "Currency from" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Turkish lira'     |
			And I select current line in "List" table
			And I select "Banknote Buying" exact value from "Download rate type" drop-down list
			And I input "#KeyTcmbGovTr#" text in "Key" field
			And I click "Ok" button
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description'      |
				| 'Forex Seling'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'           |
				| 'ExternalTCMBGovTr'     |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "Settings" button
			And I click Select button of "Currency from" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Turkish lira'     |
			And I select current line in "List" table
			And I select "Banknote Selling" exact value from "Download rate type" drop-down list
			And I input "#KeyTcmbGovTr#" text in "Key" field
			And I click "Ok" button
			And I click "Save and close" button
		* Check connection
			Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
			And I go to line in "List" table
				| 'Description'     |
				| 'Bank UA'         |
			And I select current line in "List" table
			And in the table "ConnectionSetting" I click "Test" button
			// Given Recent TestClient message contains "Received response from bank.gov.ua:443 Status code: 200" string			
			And Delay 80
		And I close all client application windows
		
Scenario: _0200001 check preparation
	When check preparation

Scenario: _020001 check load currency rate from tcmb.gov.tr
	And I turn on asynchronous execution mode with interval "1"
	* Open catalog currency
		Given I open hyperlink "e1cib/list/Catalog.Currencies"
	* Upload currency rate Forex Buying (from tcmb.gov.tr)
		And I click "Integrations" button
		And I go to line in "IntegrationTable" table
			| Integration settings    |
			| Forex Buying            |
		And I click "Ok" button
		And I click Select button of "Period" field
		And I click "Clear period" button
		And I input begin of the current month date in "DateBegin" field
		And I input current date in "DateEnd" field
		And I click "Select" button
		And I go to line in "Currencies" table
			| 'Code'    |
			| 'USD'     |
		And I set "Download" checkbox in "Currencies" table
		And I finish line editing in "Currencies" table
		And I go to line in "Currencies" table
			| 'Code'    |
			| 'EUR'     |
		And I set "Download" checkbox in "Currencies" table
		And I finish line editing in "Currencies" table
		And in the table "Currencies" I click "Download" button
		And Delay 20
		And I close all client application windows
	* Upload currency rate Forex Selling (from tcmb.gov.tr)
		Given I open hyperlink "e1cib/list/Catalog.Currencies"
		And I click "Integrations" button
		And I go to line in "IntegrationTable" table
			| Integration settings    |
			| Forex Seling            |
		And I click "Ok" button
		And I click Select button of "Period" field
		And I click "Clear period" button
		And I input begin of the current month date in "DateBegin" field
		And I input current date in "DateEnd" field
		And I click "Select" button
		And I go to line in "Currencies" table
			| Code    |
			| USD     |
		And I set "Download" checkbox in "Currencies" table
		And I finish line editing in "Currencies" table
		And in the table "Currencies" I click "Download" button
		And Delay 20
		And I close all client application windows
	* Check currency downloads
		Given I open hyperlink "e1cib/list/InformationRegister.CurrencyRates"
		And "List" table contains lines
			| 'Currency from'   | 'Currency to'   | 'Source'         | 'Multiplicity'   | 'Rate'    |
			| 'TRY'             | 'USD'           | 'Forex Seling'   | '1'              | '*'       |
			| 'TRY'             | 'USD'           | 'Forex Seling'   | '1'              | '*'       |
			| 'TRY'             | 'USD'           | 'Forex Buying'   | '1'              | '*'       |
			| 'TRY'             | 'EUR'           | 'Forex Buying'   | '1'              | '*'       |
		And I close all client application windows

Scenario: _020002 check load currency rate from bank.gov.ua
	* Preparation
		If "$isProdMode$" variable is equal to "True" Then
			Then I stop script execution "Skipped"
	* Upload currency rate Bank UA (from bank.gov.ua)
		Given I open hyperlink "e1cib/list/Catalog.Currencies"
		And I click "Integrations" button
		And I go to line in "IntegrationTable" table
			| Integration settings    |
			| Bank UA                 |
		And I click "Ok" button
		And I click Select button of "Period" field
		And I click "Clear period" button
		And I input begin of the current month date in "DateBegin" field
		And I input current date in "DateEnd" field
		And I click "Select" button
		And I go to line in "Currencies" table
			| 'Code'    |
			| 'USD'     |
		And I set "Download" checkbox in "Currencies" table
		And I finish line editing in "Currencies" table
		And I go to line in "Currencies" table
			| 'Code'    |
			| 'EUR'     |
		And I set "Download" checkbox in "Currencies" table
		And I finish line editing in "Currencies" table
		And I go to line in "Currencies" table
			| 'Code'    |
			| 'TRY'     |
		And I set "Download" checkbox in "Currencies" table
		And I finish line editing in "Currencies" table
		And in the table "Currencies" I click "Download" button
		And Delay 20
		And I close all client application windows
	* Check currency downloads
		Given I open hyperlink "e1cib/list/InformationRegister.CurrencyRates"
		And "List" table contains lines
			| 'Currency from'   | 'Currency to'   | 'Source'    | 'Multiplicity'   | 'Rate'    |
			| 'UAH'             | 'USD'           | 'Bank UA'   | '1'              | '*'       |
			| 'UAH'             | 'EUR'           | 'Bank UA'   | '1'              | '*'       |
			| 'UAH'             | 'TRY'           | 'Bank UA'   | '1'              | '*'       |

Scenario: _020003 delete integration settings
	* Delete integration settings
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I go to line in "List" table
			| 'Description'     |
			| 'Forex Buying'    |
		And I activate field named "Description" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* Open catalog currency
		Given I open hyperlink "e1cib/list/Catalog.Currencies"
	* Upload currency rate Forex Buying (from tcmb.gov.tr)
		And I click "Integrations" button
		And "IntegrationTable" table does not contain lines
			| Integration settings    |
			| Forex Buying            |
		And I close all client application windows
		
		
Scenario: _999999 close TestClient session
	Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
	And I go to line in "List" table
		| 'Description'    |
		| 'Forex Seling'   |
	And I select current line in "List" table
	And I click "Settings" button
	And I input "" text in "Key" field
	And I click "Ok" button
	And I click "Save and close" button
	And I go to line in "List" table
		| 'Description'    |
		| 'Forex Buying'   |
	And I select current line in "List" table
	And I click "Settings" button
	And I input "" text in "Key" field
	And I click "Ok" button
	And I click "Save and close" button
	And I close TestClient session
