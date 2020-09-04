#language: en
@tree
@Positive
@Test
@Group01

Feature: filling in Cash/Bank accounts catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"



Scenario: _005018 filling in the "Cash/Bank accounts" catalog
	* Preparation
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
	* Opening the form for filling in Accounts
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And Delay 2
		And I click the button named "FormCreate"
	* Create and check the creation of Cash account: Cash desk №1 (with fix currency), Cash desk №2 (multi currency)
		And I click Open button of the field named "Description_en"
		And I input "Cash desk №1" text in the field named "Description_en"
		And I input "Cash desk №1 TR" text in the field named "Description_tr"
		And I input "Касса №1" text in the field named "Description_ru"
		And I click "Ok" button
		Then the form attribute named "Type" became equal to "Cash"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I change the radio button named "CurrencyType" value to "Fixed"
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Type" became equal to "Cash"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the form attribute named "Number" became equal to ""
			Then the form attribute named "BankName" became equal to ""
			Then the form attribute named "TransitAccount" became equal to ""
			Then the form attribute named "Description_en" became equal to "Cash desk №1"
			Then the form attribute named "CurrencyType" became equal to "Fixed"
			Then the form attribute named "Currency" became equal to "USD"
		And I click the button named "FormWriteAndClose"
		And Delay 5
		Then I check for the "CashAccounts" catalog element with the "Description_en" "Cash desk №1"  
		Then I check for the "CashAccounts" catalog element with the "Description_tr" "Cash desk №1 TR" 
		Then I check for the "CashAccounts" catalog element with the "Description_ru" "Касса №1" 
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Cash desk №2" text in the field named "Description_en"
		And I input "Cash desk №2 TR" text in the field named "Description_tr"
		And I click "Ok" button
		Then the form attribute named "Type" became equal to "Cash"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Type" became equal to "Cash"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the form attribute named "Number" became equal to ""
			Then the form attribute named "BankName" became equal to ""
			Then the form attribute named "TransitAccount" became equal to ""
			Then the form attribute named "Description_en" became equal to "Cash desk №2"
			Then the form attribute named "CurrencyType" became equal to "Multi"
			Then the form attribute named "Currency" became equal to ""
		And I click the button named "FormWriteAndClose"
		And Delay 5
		Then I check for the "CashAccounts" catalog element with the "Description_en" "Cash desk №2"  
		Then I check for the "CashAccounts" catalog element with the "Description_tr" "Cash desk №2 TR" 
	* Create and check the creation of bank account: Bank account TRY
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Bank account, TRY" text in the field named "Description_en"
		And I click "Ok" button
		And I change the radio button named "Type" value to "Bank"
		And I input "112000000018" text in "Number" field
		And I input "OTP" text in "Bank name" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| Code | Description  |
			| TRY  | Turkish lira |
		And I select current line in "List" table
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Type" became equal to "Bank"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the form attribute named "Number" became equal to "112000000018"
			Then the form attribute named "BankName" became equal to "OTP"
			Then the form attribute named "Description_en" became equal to "Bank account, TRY"
			Then the form attribute named "CurrencyType" became equal to "Fixed"
			Then the form attribute named "Currency" became equal to "TRY"
		And I click the button named "FormWriteAndClose"
		And Delay 5
		Then I check for the "CashAccounts" catalog element with the "Description_en" "Bank account, TRY"  
	* Create Transit bank account
		* Create Transit Main
			And I click the button named "FormCreate"
			And I click Open button of the field named "Description_en"
			And I input "Transit Main" text in the field named "Description_en"
			And I click "Ok" button
			And I change the radio button named "Type" value to "Transit"
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click the button named "FormWrite"
			* Check data save	
				Then the form attribute named "Type" became equal to "Transit"
				Then the form attribute named "Company" became equal to "Main Company"
				Then the form attribute named "Number" became equal to ""
				Then the form attribute named "BankName" became equal to ""
				Then the form attribute named "TransitAccount" became equal to ""
				Then the form attribute named "Description_en" became equal to "Transit Main"
				Then the form attribute named "CurrencyType" became equal to "Multi"
				Then the form attribute named "Currency" became equal to ""
			And I click the button named "FormWriteAndClose"
			And Delay 5
			Then I check for the "CashAccounts" catalog element with the "Description_en" "Transit Main"
	* Filling Transit account in the Bank account, TRY
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
		And I click Select button of "Transit account" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Transit Main' |
		And I select current line in "List" table
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "TransitAccount" became equal to "Transit Main"
			And I click the button named "FormWriteAndClose"
	* Clean catalog CashAccounts
		And I delete "CashAccounts" catalog element with the Description_en "Cash desk №1"
		And I delete "CashAccounts" catalog element with the Description_en "Cash desk №2"
		And I delete "CashAccounts" catalog element with the Description_en "Bank account, TRY"
		And I delete "CashAccounts" catalog element with the Description_en "Transit Main"
