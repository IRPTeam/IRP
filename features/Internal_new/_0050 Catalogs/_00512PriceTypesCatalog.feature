#language: en
@tree
@Positive
@Test
@Group01
@Catalogs

Feature: filling in Price types catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"




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
	* Clean catalog
		And I delete "PriceTypes" catalog element with the Description_en "Basic Price Types"
