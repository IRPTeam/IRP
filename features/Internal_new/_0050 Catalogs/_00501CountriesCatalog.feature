#language: en
@tree
@Positive
@Catalogs

Feature: filling in Countries catalogs

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one




Scenario: _005010 filling in the "Countries" catalog
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Clearing the Countries catalog
		And I close all client application windows
	* Open Country creation form
		Given I open hyperlink "e1cib/list/Catalog.Countries"
		And I click the button named "FormCreate"
	* Data Filling - Turkey
		And I click Open button of the field named "Description_en"
		And I input "Poland" text in the field named "Description_en"
		And I input "Poland TR" text in the field named "Description_tr"
		And I input "Польша" text in "RU" field
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
		Then I check for the "Countries" catalog element with the "Description_en" "Poland"
		Then I check for the "Countries" catalog element with the "Description_tr" "Poland TR"
		Then I check for the "Countries" catalog element with the "Description_ru" "Польша"
		Then I check for the "Countries" catalog element with the "Description_en" "Ukraine"
		Then I check for the "Countries" catalog element with the "Description_tr" "Ukraine TR"
		Then I check for the "Countries" catalog element with the "Description_ru" "Украина"
	# * Clean catalog Countries
	# 	And I delete "Countries" catalog element with the Description_en "Turkey"
	# 	And I delete "Countries" catalog element with the Description_en "Ukraine"