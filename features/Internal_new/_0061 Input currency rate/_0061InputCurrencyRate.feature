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
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"


Scenario: _006100 preparation (filling in currency rates)
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