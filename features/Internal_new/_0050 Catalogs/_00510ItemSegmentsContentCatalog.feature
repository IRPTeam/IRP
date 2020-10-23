#language: en
@tree
@Positive
@Catalogs

Feature: filling in Item segments content catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one



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
