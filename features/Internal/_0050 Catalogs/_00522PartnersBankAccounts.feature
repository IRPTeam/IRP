#language: en
@tree
@Positive
@PartnerCatalogs

Feature: filling in Partners bank account

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one





Scenario: _005022 filling in the "Partners bank account" catalog
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When Create catalog Partners objects (Kalipso)
	When Create catalog Currencies objects
	When Create catalog BusinessUnits objects
	When Create catalog Companies objects (partners company)
	* Opening the form for filling in Partners bank account
		Given I open hyperlink "e1cib/list/Catalog.PartnersBankAccounts"
		And I click the button named "FormCreate"
		And I click Open button of "ENG" field
		And I input "Partner bank account" text in "ENG" field
		And I input "Partner bank account TR" text in "TR" field
		And I input "Банковский счет партнера" text in "RU" field
		And I click "Ok" button
		And I input "56788888888888689" text in "Number" field
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description' |
			| 'Euro'        |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I input "Bank name" text in "Bank name" field
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'Front office'     |
		And I select current line in "List" table
		And I click "Save" button
		* Check data save
			Then the form attribute named "Description_en" became equal to "Partner bank account"
			Then the form attribute named "Partner" became equal to "Kalipso"
			Then the form attribute named "LegalEntity" became equal to "Company Kalipso"
			Then the form attribute named "BankName" became equal to "Bank name"
			Then the form attribute named "BusinessUnit" became equal to "Front office"
			Then the form attribute named "Number" became equal to "56788888888888689"
			Then the form attribute named "Currency" became equal to "EUR"	
	* Check for created Partners bank account
		Then I check for the "PartnersBankAccounts" catalog element with the "Description_en" "Partner bank account"  
	

	