#language: en
@tree
@Positive
@Test
@Group01
@Catalogs

Feature: filling in Units catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"



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
	* Clean catalog Units
		And I delete "Units" catalog element with the Description_en "pcs"
		And I delete "Units" catalog element with the Description_en "box (4 pcs)"
