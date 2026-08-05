#language: en
@tree
@Positive
@PartnerCatalogs

Feature: filling in Partners catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one





Scenario: _005022 filling in the "Partners" catalog
	When set True value to the constant
	When Create chart of characteristic types CurrencyMovementType objects
	When Create catalog Currencies objects
	When Create catalog IntegrationSettings objects
	* Opening the form for filling in Partners
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And Delay 2
	* Create partners: Ferron BP (customer and vendor), Kalipso (customer), Manager B (Employee), Lomaniti(vendor)
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Ferron1 BP" text in the field named "Description_en"
		And I input "Ferron1 BP TR" text in the field named "Description_tr"
		And I input "Феррон BP" text in the field named "Description_ru"
		And I click "Ok" button
		And I set checkbox named "Customer"
		And I set checkbox named "Vendor"
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Ferron1 BP"
			Then the form attribute named "Customer" became equal to "Yes"
			Then the form attribute named "Vendor" became equal to "Yes"
			Then the form attribute named "Employee" became equal to "No"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Kalipso1" text in the field named "Description_en"
		And I input "Kalipso1 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Customer"
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Kalipso1"
			Then the form attribute named "Customer" became equal to "Yes"
			Then the form attribute named "Vendor" became equal to "No"
			Then the form attribute named "Employee" became equal to "No"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Manager B" text in the field named "Description_en"
		And I input "Manager B TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Employee"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Manager B"
			Then the form attribute named "Customer" became equal to "No"
			Then the form attribute named "Vendor" became equal to "No"
			Then the form attribute named "Employee" became equal to "Yes"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Lomaniti1" text in the field named "Description_en"
		And I input "Lomaniti1 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Vendor"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Lomaniti1"
			Then the form attribute named "Customer" became equal to "No"
			Then the form attribute named "Vendor" became equal to "Yes"
			Then the form attribute named "Employee" became equal to "No"
		And I click the button named "FormWriteAndClose"
	* Create other partner
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Other partner" text in the field named "Description_en"
		And I input "Other partner TR" text in the field named "Description_tr"
		And I input "Другие" text in the field named "Description_ru"
		And I click "Ok" button
		And I set checkbox named "Other"
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Other partner"
			Then the form attribute named "Customer" became equal to "No"
			Then the form attribute named "Vendor" became equal to "No"
			Then the form attribute named "Employee" became equal to "No"
			Then the form attribute named "Other" became equal to "Yes"
		And I click the button named "FormWriteAndClose"
	* Check for created partners
		Then I check for the "Partners" catalog element with the "Description_en" "Ferron1 BP"  
		Then I check for the "Partners" catalog element with the "Description_tr" "Ferron1 BP TR"
		Then I check for the "Partners" catalog element with the "Description_ru" "Феррон BP"
		Then I check for the "Partners" catalog element with the "Description_en" "Kalipso1"
		Then I check for the "Partners" catalog element with the "Description_en" "Manager B"
		And Delay 2
		Then I check for the "Partners" catalog element with the "Description_en" "Lomaniti1"
		Then I check for the "Partners" catalog element with the "Description_en" "Other partner"
	
Scenario: _005023 name uniqueness control (Partners)
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		If "List" table does not contain lines Then
			| 'Description' |
			| 'Ferron1 BP'       |
			Then I stop script execution "Skipped"
	* Create partner
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Ferron1 BP" text in the field named "Description_en"
		And I input "Ferron1 BP TR" text in the field named "Description_tr"
		And I input "Феррон BP" text in the field named "Description_ru"
		And I click "Ok" button
		And I set checkbox named "Vendor"
		And I click the button named "FormWriteAndClose"
	* Check uniqueness control
		Then there are lines in TestClient message log
			|'Description not unique [Ferron1 BP]'|
		And I click Open button of the field named "Description_en"
		And I input "1" text in the field named "Description_en"	
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		Then there are lines in TestClient message log
			|'Description not unique [Ferron1 BP]'|	
		And I click Open button of the field named "Description_en"
		And I input "1" text in the field named "Description_tr"	
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		Then there are lines in TestClient message log
			|'Description not unique [Ferron1 BP]'|	
		And I close all client application windows

Scenario: _0050234 required partner type checkbox 
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.Partners"
	And I click the button named "FormCreate"
	And Delay 2
	And I input "Test partner" text in "ENG" field
	And I click the button named "FormWriteAndClose"
	Then there are lines in TestClient message log
		|'Partner type is required'|
	
Scenario: _0050235 control of Multicurrency movement type (Partnerterms)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.Partners"
	* Create partner
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Corn EN" text in the field named "Description_en"
		And I input "Corn TR" text in the field named "Description_tr"
		And I input "Корн РУ" text in the field named "Description_ru"
		And I click "Ok" button
		And I set checkbox named "Vendor"
		And I click the button named "FormWrite"
		And In this window I click command interface button "Company"
		And I click "Yes" button
	* Create partner term (more than 1 Partner term currency)
		And In this window I click command interface button "Partner terms"
		And I click "Yes" button
		Then the form attribute named "CurrencyMovementType" became equal to ""
	* Create partner term (only 1 Partner term currency)
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.CurrencyMovementType"
		And I go to line in "List" table
			| "Currency" | "Deferred calculation" | "Description" | "Type"         |
			| "EUR"      | "No"                   | "EUR"         | "Partner term" |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		And I click "Yes" button
		And I go to line in "List" table
			| "Currency" | "Deferred calculation" | "Description" | "Type"         |
			| "USD"      | "No"                   | "USD"         | "Partner term" |
		And I activate field named "Type" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I close "Multi currency movement types" window
		And I close "Partner term (create)" window
		And I close "Corn EN (Partner)" window
		And I go to line in "List" table
			| "Description" |
			| "Corn EN"     |
		And I select current line in "List" table
		And In this window I click command interface button "Partner terms"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then the form attribute named "CurrencyMovementType" became equal to "TRY"
		And I click Open button of "Multi currency movement type" field
		And I activate current test client window
		And Delay 1
		And I set checkbox "Not post if rate not set"
		And I remove checkbox "Not post if rate not set"
		Then the form attribute named "Type" became equal to "Partner term"
		And I close current window
		If "1C:Enterprise" window is opened Then
			And I click "No" button	
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.CurrencyMovementType"
		And I go to line in "List" table
			| "Currency" | "Deferred calculation" | "Description" | "Type"         |
			| "EUR"      | "No"                   | "EUR"         | "Partner term" |
		And I activate field named "Type" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I go to line in "List" table
			| "Currency" | "Deferred calculation" | "Description" | "Type"         |
			| "USD"      | "No"                   | "USD"         | "Partner term" |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	And I close all client application windows