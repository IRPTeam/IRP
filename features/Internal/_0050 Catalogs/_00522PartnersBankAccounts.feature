#language: en
@tree
@Positive
@PartnerCatalogs

Feature: filling in Partners bank account and Legal name contract

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one





Scenario: _005022 filling in the "Partners bank account" catalog
	When set True value to the constant
	When Create catalog Partners objects (Kalipso)
	When Create catalog Currencies objects
	When Create catalog BusinessUnits objects
	When Create catalog Companies objects (partners company)
	When Create catalog Countries objects
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
			| 'Description'    |
			| 'Euro'           |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I input "Bank name" text in "Bank name" field
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I click "Save" button
		* Check data save
			Then the form attribute named "Description_en" became equal to "Partner bank account"
			Then the form attribute named "Partner" became equal to "Kalipso"
			Then the form attribute named "LegalEntity" became equal to "Company Kalipso"
			Then the form attribute named "BankName" became equal to "Bank name"
			Then the form attribute named "Branch" became equal to "Front office"
			Then the form attribute named "Number" became equal to "56788888888888689"
			Then the form attribute named "Currency" became equal to "EUR"	
	* Check for created Partners bank account
		Then I check for the "PartnersBankAccounts" catalog element with the "Description_en" "Partner bank account"  
	

Scenario: _005025 filling in the "Legal name contracts" catalog	
	And I close all client application windows
	* Open "Legal name contracts" catalog	
		Given I open hyperlink "e1cib/list/Catalog.LegalNameContracts"		
		And I click the button named "FormCreate"
	* Filling details
		Then "Legal name contract (create)" window is opened
		And I input "Legal name contract 1 dated 01.01.2023" text in the field named "Description"
		And I input "1" text in "Contract number" field
		And I input "01.01.2023" text in "Begin date" field
		And I input "31.12.2023" text in "End date" field
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from "Legal name" drop-down list by "Company Kalipso" string
		And I select from the drop-down list named "Currency" by "EUR" string
		And I click Select button of "Partner bank account" field
		Then "Partners bank accounts" window is opened
		And I go to line in "List" table
			| 'Description'          | 'Number'            |
			| 'Partner bank account' | '56788888888888689' |
		And I select current line in "List" table
		And I click "Save" button
	* Check data save
		And the editing text of form attribute named "BeginDate" became equal to "01.01.2023"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "ContractNumber" became equal to "1"
		Then the form attribute named "Currency" became equal to "EUR"
		Then the form attribute named "Description" became equal to "Legal name contract 1 dated 01.01.2023"
		And the editing text of form attribute named "EndDate" became equal to "31.12.2023"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "PartnerBankAccount" became equal to "Partner bank account"
		And I click "Save and close" button 
	* Check for created Partners bank account
		And "List" table contains lines
			| 'Description'                            | 'Begin date' | 'End date'   | 'Company'      | 'Partner bank account' |
			| 'Legal name contract 1 dated 01.01.2023' | '01.01.2023' | '31.12.2023' | 'Main Company' | 'Partner bank account' |
		And I close all client application windows		