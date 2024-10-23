#language: en
@tree
@Positive
@SettingsCatalogs


Feature: filling in Business units catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one





Scenario: _005046 filling in Business units
	When set True value to the constant
	* Open a creation form Business units
		Given I open hyperlink "e1cib/list/Catalog.BusinessUnits"
	* Check hierarchical
		When create Groups in the catalog				
	* Create business unit 'Front office 01'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Front office 01" text in the field named "Description_en"
		And I input "Front office 01 TR" text in the field named "Description_tr"
		And I input "Центральный офис 01" text in "RU" field
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Front office 01"
		And I click the button named "FormWriteAndClose"
	* Create business unit 'Accountants office 01'
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Accountants office 01" text in the field named "Description_en"
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Accountants office 01"
		And I click the button named "FormWriteAndClose"
	* Check creation Business units
		Then I check for the "BusinessUnits" catalog element with the "Description_en" "Front office 01"
		Then I check for the "BusinessUnits" catalog element with the "Description_tr" "Front office 01 TR"
		Then I check for the "BusinessUnits" catalog element with the "Description_ru" "Центральный офис 01"
		Then I check for the "BusinessUnits" catalog element with the "Description_en" "Accountants office 01"

