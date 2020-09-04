#language: en
@tree
@Positive
@Test
@Group01

Feature: filling in AccessProfiles catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"



Scenario: _005016 filling in the "AccessProfiles" catalog
	* Opening the form for filling in AccessProfiles
		Given I open hyperlink "e1cib/list/Catalog.AccessProfiles"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
	* Data Filling - management
		And I click Open button of the field named "Description_en"
		And I input "Management" text in the field named "Description_en"
		And I input "Management TR" text in the field named "Description_tr"
		And I input "Руководство" text in the field named "Description_ru"
		And I click "Ok" button
		And in the table "Roles" I click "Update roles" button
		* Set up access for admin
			And in the table "Roles" I click "Update roles" button
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation' | 'Use' |
				| 'IRP'           | 'Full access'  | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'     | 'Use' |
				| 'IRP'           | 'Run thick client' | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'    | 'Use' |
				| 'IRP'           | 'Run thin client' | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'   | 'Use' |
				| 'IRP'           | 'Run web client' | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'      | 'Use' |
				| 'IRP'           | 'Run mobile client' | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation' | 'Use' |
				| 'IRP'           | 'Basic role'   | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I click the button named "FormWriteAndClose"
			And I wait "User access profiles (create)" window closing in 20 seconds
	* Data Filling - Logistic team
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Logistic team" text in the field named "Description_en"
		And I input "Logistic team TR" text in the field named "Description_tr"
		And I click "Ok" button
		And in the table "Roles" I click "Update roles" button
		* Set up access for the Logistic team
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'    | 'Use' |
				| 'IRP'           | 'Run thin client' | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'   | 'Use' |
				| 'IRP'           | 'Run web client' | 'No'  |
			And I change "Use" checkbox in "Roles" table
		And I click the button named "FormWriteAndClose"
	* Check for created User access profiles
		Then I check for the "AccessProfiles" catalog element with the "Description_en" "Management"  
		Then I check for the "AccessProfiles" catalog element with the "Description_tr" "Management TR"
		Then I check for the "AccessProfiles" catalog element with the "Description_ru" "Руководство"
	* Clean catalog AccessProfiles
		And I delete "AccessProfiles" catalog element with the Description_en "Management"
		And I delete "AccessProfiles" catalog element with the Description_en "Logistic team"
