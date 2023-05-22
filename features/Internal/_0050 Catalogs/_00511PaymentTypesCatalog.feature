#language: en
@tree
@Positive
@SettingsCatalogs

Feature: filling in Payment types catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one


Scenario: preparation (Payment types settings)
	When Create catalog CashAccounts objects
	When Create catalog PaymentTypes objects
	When Create catalog BusinessUnits objects

Scenario: _005027 filling in the "Payment types" catalog  
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Opening a form and creating Payment types
		Given I open hyperlink "e1cib/list/Catalog.PaymentTypes"
		When create a catalog element with the name Test
		And I close current window
	* Check for created Payment types
		Then I check for the "PaymentTypes" catalog element with the "Description_en" "Test ENG"  
		Then I check for the "PaymentTypes" catalog element with the "Description_tr" "Test TR"

Scenario: _005028 filling in the "Payment terminal" catalog  
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Opening a form and creating Payment types
		Given I open hyperlink "e1cib/list/Catalog.PaymentTerminals"
		When create a catalog element with the name Test
		And I close current window
	* Check for created Payment types
		Then I check for the "PaymentTerminals" catalog element with the "Description_en" "Test ENG"  
		Then I check for the "PaymentTerminals" catalog element with the "Description_tr" "Test TR"


Scenario: _005029 filling in the "BankTerms" catalog 
		And I close all client application windows
	* Bank terms
		Given I open hyperlink "e1cib/list/Catalog.BankTerms"
		And I click the button named "FormCreate"
		And I input "Bank term 01" text in "ENG" field
		And in the table "PaymentTypes" I click the button named "PaymentTypesAdd"
		And I click choice button of "Payment type" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 01'     |
		And I select current line in "List" table
		And I activate "Account" field in "PaymentTypes" table
		And I click choice button of "Account" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Transit Main' |
		And I select current line in "List" table
		And I activate "Percent" field in "PaymentTypes" table
		And I input "1,00" text in "Percent" field of "PaymentTypes" table
		And I finish line editing in "PaymentTypes" table
		And in the table "PaymentTypes" I click the button named "PaymentTypesAdd"
		And I click choice button of "Payment type" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 02'     |
		And I select current line in "List" table
		And I activate "Account" field in "PaymentTypes" table
		And I click choice button of "Account" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Transit Second' |
		And I select current line in "List" table
		And I activate "Percent" field in "PaymentTypes" table
		And I input "2,00" text in "Percent" field of "PaymentTypes" table
		And I finish line editing in "PaymentTypes" table
		And I click "Save" button
		And In this window I click command interface button "Branch bank terms"
		And I click the button named "FormCreate"
		Then "Branch bank term (create)" window is opened
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I click Select button of "Bank term" field
		Then "Bank terms" window is opened
		And I select current line in "List" table
		And I click "Save and close" button	
	* Check for created Payment types
		Then I check for the "BankTerms" catalog element with the "Description_en" "Bank term 01"  	