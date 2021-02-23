#language: en
@tree
@Positive
@UserCatalogs

Feature: filling in AccessGroups catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one




Scenario: _005015 filling in the "AccessGroups" catalog
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Opening the form for filling in AccessGroups
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
		And I click the button named "FormCreate"
	* Data Filling - Admin
		And I click Open button of the field named "Description_en"
		And I input "Admin" text in the field named "Description_en"
		And I input "Admin TR" text in the field named "Description_tr"
		And I input "Админ" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Access group creation "Manager"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Manager" text in the field named "Description_en"
		And I input "Manager TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
	* Check for created AccessGroups
		Then I check for the "AccessGroups" catalog element with the "Description_en" "Admin"
		Then I check for the "AccessGroups" catalog element with the "Description_tr" "Admin TR"
		Then I check for the "AccessGroups" catalog element with the "Description_ru" "Админ"
		And Delay 5
		Then I check for the "AccessGroups" catalog element with the "Description_en" "Manager"
	# * Clean catalog AccessGroups
	# 	And I delete "AccessGroups" catalog element with the Description_en "Admin"
	# 	And I delete "AccessGroups" catalog element with the Description_en "Manager"

