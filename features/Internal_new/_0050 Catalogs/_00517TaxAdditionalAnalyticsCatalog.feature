#language: en
@tree
@Positive
@Test
@Group01


Feature: filling in Tax additional analytics catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"


	

Scenario: _005048 filling in "Tax additional analytics" catalog
	* Open and filling in Tax additional analytics
		Given I open hyperlink "e1cib/list/Catalog.TaxAnalytics"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Analytics 01" text in the field named "Description_en"
		And I input "Analytics 01 TR" text in the field named "Description_tr"
		And I input "Аналитика 01" text in "RU" field
		And I click "Ok" button
		And I click "Save and close" button
		And I close all client application windows
		And Delay 2
	* Check for created  Tax additional analytics
		Then I check for the "TaxAnalytics" catalog element with the "Description_en" "Analytics 01"  
		Then I check for the "TaxAnalytics" catalog element with the "Description_tr" "Analytics 01 TR"
		Then I check for the "TaxAnalytics" catalog element with the "Description_ru" "Аналитика 01"

