#language: en
@tree
@Positive
@Catalogs

Feature: filling in Tax rates catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"





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
