#language: en
@tree
@Positive
@Catalogs


Feature: filling in Business units catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one





Scenario: _005046 filling in Business units
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Open a creation form Business units
		Given I open hyperlink "e1cib/list/Catalog.BusinessUnits"
	* Create business unit 'Front office'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Front office" text in the field named "Description_en"
		And I input "Front office TR" text in the field named "Description_tr"
		And I input "Центральный офис" text in "RU" field
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Front office"
		And I click the button named "FormWriteAndClose"
	* Create business unit 'Accountants office'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Accountants office" text in the field named "Description_en"
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Accountants office"
		And I click the button named "FormWriteAndClose"
	* Check creation Business units
		Then I check for the "BusinessUnits" catalog element with the "Description_en" "Front office"
		Then I check for the "BusinessUnits" catalog element with the "Description_tr" "Front office TR"
		Then I check for the "BusinessUnits" catalog element with the "Description_ru" "Центральный офис"
		Then I check for the "BusinessUnits" catalog element with the "Description_en" "Accountants office"

