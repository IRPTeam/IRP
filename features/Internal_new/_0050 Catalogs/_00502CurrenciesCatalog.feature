#language: en
@tree
@Positive
@Catalogs

Feature: filling in Currencies catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one





Scenario: _005011 filling in the "Currencies" catalog
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
	# * Clean catalog Currencies
	# 	And I delete "Currencies" catalog element with the Description_en "American dollar"
	# 	And I delete "Currencies" catalog element with the Description_en "Euro"
