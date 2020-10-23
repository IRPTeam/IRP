#language: en
@tree
@Positive
@CurrencyRate


Feature: filling in currency rates in registers

As an accountant
I want to fill out the exchange rate
To use multi-currency accounting

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _006100 preparation (filling in currency rates)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Add Pluginsessor ExternalBankUa
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		And I click the button named "FormCreate"
		And I select external file "#workingDir#\DataProcessor\bank_gov_ua.epf"
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
	* Add Pluginsessor ExternalTCMBGovTr
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		And I click the button named "FormCreate"
		And I select external file "#workingDir#\DataProcessor\tcmb_gov_tr.epf"
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
	When Create catalog Currencies objects
	Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
	If "List" table does not contain line Then
		| "Description" |
		| "Forex Seling" |
		When create setting to download the course (Forex Seling)


Scenario: _006101 filling in exchange rates in registers
	* Opening of register CurrencyRates
		Given I open hyperlink "e1cib/list/InformationRegister.CurrencyRates"
	* Filling the lira to euro rate
		And I click the button named "FormCreate"
		And I click Select button of "Currency from" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I click Select button of "Currency to" field
		And I go to line in "List" table
			| Code |
			| EUR  |
		And I select current line in "List" table
		And I click Select button of "Source" field
		And I go to line in "List" table
			| Description    |
			| Forex Seling |
		And I select current line in "List" table
		And I input "1" text in "Multiplicity" field
		And I input "6,54" text in "Rate" field
		And I input "21.06.2019 17:40:13" text in "Period" field
		And I click "Save and close" button
	* Filling the lira to USD rate
		And I click the button named "FormCreate"
		And I click Select button of "Currency from" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I click Select button of "Currency to" field
		And I go to line in "List" table
			| Code |
			| USD  |
		And I select current line in "List" table
		And I click Select button of "Source" field
		And I go to line in "List" table
			| Description    |
			| Forex Seling |
		And I select current line in "List" table
		And I input "1" text in "Multiplicity" field
		And I input "5,84" text in "Rate" field
		And I input "21.06.2019 17:40:13" text in "Period" field
		And I click "Save and close" button
	* Filling the lira to lira rate
		And I click the button named "FormCreate"
		And I click Select button of "Currency from" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I click Select button of "Currency to" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I click Select button of "Source" field
		And I go to line in "List" table
			| Description    |
			| Forex Seling |
		And I select current line in "List" table
		And I input "1" text in "Multiplicity" field
		And I input "1" text in "Rate" field
		And I input "01.01.2019 17:40:13" text in "Period" field
		And I click "Save and close" button
	* Filling the USD to euro rate
		And I click the button named "FormCreate"
		And I click Select button of "Currency from" field
		And I go to line in "List" table
			| Code |
			| USD  |
		And I select current line in "List" table
		And I click Select button of "Currency to" field
		And I go to line in "List" table
			| Code |
			| EUR  |
		And I select current line in "List" table
		And I click Select button of "Source" field
		And I go to line in "List" table
			| Description    |
			| Forex Seling |
		And I select current line in "List" table
		And I input "1" text in "Multiplicity" field
		And I input "0,8900" text in "Rate" field
		And I input "21.06.2019 17:40:13" text in "Period" field
		And I click "Save and close" button
	* Filling the USD to lira rate
		And I click the button named "FormCreate"
		And I click Select button of "Currency from" field
		And I go to line in "List" table
			| Code |
			| USD  |
		And I select current line in "List" table
		And I click Select button of "Currency to" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I click Select button of "Source" field
		And I go to line in "List" table
			| Description    |
			| Forex Seling |
		And I select current line in "List" table
		And I input "1" text in "Multiplicity" field
		And I input "0,1770" text in "Rate" field
		And I input "21.06.2019 17:40:13" text in "Period" field
		And I click "Save and close" button
		
Scenario: _999999 close TestClient session
	And I close TestClient session