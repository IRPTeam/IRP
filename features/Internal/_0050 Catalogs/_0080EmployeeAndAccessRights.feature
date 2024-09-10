#language: en
@tree
@Positive
@UserCatalogs


Feature: access rights

As an owner
I want to create users
To restrict user access rights

Background:
	Given I open new TestClient session or connect the existing one




Scenario: _008004 filling in the "Users" catalog 
	When set True value to the constant
	* Preparation
		And I close all client application windows
		When Create catalog Partners objects (Employee)
		When Create catalog UserGroups objects
	* Opening the form for filling in users
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
	* User creation Commercial Agent 1
		And I click Open button of the field named "Description_en"
		And I input "Daniel Smith (Commercial Agent 1)" text in the field named "Description_en"
		And I input "Daniel Smith (Commercial Agent 1) TR" text in the field named "Description_tr"
		And I input "Даниэль Смит (Торговый агент 1)" text in the field named "Description_ru"
		And I click "Ok" button
		And I input "DSmith" text in "Login" field
		And I select "English" exact value from "Data localization" drop-down list
		And I select "English" exact value from "Interface localization" drop-down list
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Daniel Smith'    |
		And I select current line in "List" table
		And I select "Compact" exact value from "Form scale variant" drop-down list
		And I click Select button of "User group" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Admin'          |
		And I select current line in "List" table
		And I set checkbox named "ShowInList"
		And I click the button named "FormWrite"
		* Check data save
			And the field named "InfobaseUserID" is filled
			Then the form attribute named "ShowInList" became equal to "Yes"
			Then the form attribute named "Partner" became equal to "Daniel Smith"
			Then the form attribute named "UserGroup" became equal to "Admin"
			Then the form attribute named "FormScaleVariant" became equal to "Compact"
			And the editing text of form attribute named "LocalizationCode" became equal to "English"
			And the editing text of form attribute named "InterfaceLocalizationCode" became equal to "English"
			Then the form attribute named "Description" became equal to "DSmith"
			Then the form attribute named "Description_en" became equal to "Daniel Smith (Commercial Agent 1)"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* User creation Manager 1
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Olivia Williams (Manager 1)" text in the field named "Description_en"
		And I input "Olivia Williams (Manager 1) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "OWilliams" text in "Login" field
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Olivia Williams'    |
		And I select current line in "List" table
		And I select "Auto" exact value from "Form scale variant" drop-down list
		And I select "English" exact value from "Data localization" drop-down list
		And I select "Turkish" exact value from "Interface localization" drop-down list
		And I set checkbox named "ShowInList"
		And I click Select button of "User group" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Admin'          |
		And I select current line in "List" table
		And I click the button named "FormWrite"
		* Check data save
			And the field named "InfobaseUserID" is filled
			Then the form attribute named "ShowInList" became equal to "Yes"
			Then the form attribute named "Partner" became equal to "Olivia Williams"
			Then the form attribute named "UserGroup" became equal to "Admin"
			Then the form attribute named "FormScaleVariant" became equal to "Auto"
			And the editing text of form attribute named "LocalizationCode" became equal to "English"
			And the editing text of form attribute named "InterfaceLocalizationCode" became equal to "Turkish"
			Then the form attribute named "Description" became equal to "OWilliams"
			Then the form attribute named "Description_en" became equal to "Olivia Williams (Manager 1)"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* User creation Manager 2
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Emily Jones (Manager 2)" text in the field named "Description_en"
		And I input "Emily Jones (Manager 2) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "EJones" text in "Login" field
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Emily Jones'    |
		And I select current line in "List" table
		And I select "Normal" exact value from "Form scale variant" drop-down list
		And I select "Turkish" exact value from "Data localization" drop-down list
		And I select "English" exact value from "Interface localization" drop-down list
		And I set checkbox named "ShowInList"
		And I click Select button of "User group" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Admin'          |
		And I select current line in "List" table
		And I click the button named "FormWrite"
		* Check data save
			And the field named "InfobaseUserID" is filled
			Then the form attribute named "ShowInList" became equal to "Yes"
			Then the form attribute named "Partner" became equal to "Emily Jones"
			Then the form attribute named "UserGroup" became equal to "Admin"
			Then the form attribute named "FormScaleVariant" became equal to "Normal"
			And the editing text of form attribute named "LocalizationCode" became equal to "Turkish"
			And the editing text of form attribute named "InterfaceLocalizationCode" became equal to "English"
			Then the form attribute named "Description" became equal to "EJones"
			Then the form attribute named "Description_en" became equal to "Emily Jones (Manager 2)"
		And I click the button named "FormWriteAndClose"
	* User creation Manager 3
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Sofia Borisova (Manager 3)" text in the field named "Description_en"
		And I input "Sofia Borisova (Manager 3) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "SBorisova" text in "Login" field
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Sofia Borisova'    |
		And I select current line in "List" table
		And I select "Compact" exact value from "Form scale variant" drop-down list
		And I select "Turkish" exact value from "Data localization" drop-down list
		And I select "Turkish" exact value from "Interface localization" drop-down list
		And I set checkbox named "ShowInList"
		And I click Select button of "User group" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Admin'          |
		And I select current line in "List" table
		And I click the button named "FormWrite"
		* Check data save
			And the field named "InfobaseUserID" is filled
			Then the form attribute named "ShowInList" became equal to "Yes"
			Then the form attribute named "Partner" became equal to "Sofia Borisova"
			Then the form attribute named "UserGroup" became equal to "Admin"
			Then the form attribute named "FormScaleVariant" became equal to "Compact"
			And the editing text of form attribute named "LocalizationCode" became equal to "Turkish"
			And the editing text of form attribute named "InterfaceLocalizationCode" became equal to "Turkish"
			Then the form attribute named "Description" became equal to "SBorisova"
			Then the form attribute named "Description_en" became equal to "Sofia Borisova (Manager 3)"
		And I click the button named "FormWriteAndClose"
	* Check for created elements
		Then I check for the "Users" catalog element with the "Description_en" "Daniel Smith (Commercial Agent 1)"
		Then I check for the "Users" catalog element with the "Description_tr" "Daniel Smith (Commercial Agent 1) TR"
		Then I check for the "Users" catalog element with the "Description_ru" "Даниэль Смит (Торговый агент 1)"
		And Delay 5
		Then I check for the "Users" catalog element with the "Description_en" "Olivia Williams (Manager 1)"  
		Then I check for the "Users" catalog element with the "Description_en" "Emily Jones (Manager 2)"
		Then I check for the "Users" catalog element with the "Description_en" "Sofia Borisova (Manager 3)"




Scenario: _008005 assignment of access rights to users
	* Preparation
		When Create catalog AccessProfiles objects
		When Create catalog Users objects
		When Create catalog AccessGroups objects
	* Opening the User access groups catalog
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
	* Assignment of access rights to sales rep
		And I go to line in "List" table
				| 'Description'          |
				| 'Commercial Agent'     |
		And I select current line in "List" table
		And in the table "Profiles" I click the button named "ProfilesAdd"
		And I click choice button of "Profile" attribute in "Profiles" table
		And I go to line in "List" table
				| 'Description'          |
				| 'Commercial Agent'     |
		And I select current line in "List" table
		And Delay 1
		And I move to "Users" tab
		And I finish line editing in "Profiles" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 3
		And I activate "Users" window
		And I go to line in "List" table
			| 'Login'     |
			| 'DSmith'    |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 1
		And I go to line in "List" table
			| 'Login'     |
			| 'AOrlov'    |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Commercial Agent"
			And "Profiles" table became equal
				| 'Profile'              |
				| 'Manager'              |
				| 'Commercial Agent'     |
			And "Users" table contains lines
				| 'User'                                     |
				| 'Daniel Smith (Commercial Agent 1)'        |
				| 'Alexander Orlov (Commercial Agent 2)'     |
			And I click the button named "FormWriteAndClose"
	* Assignment of access rights to managers
		And I go to line in "List" table
			| 'Description'    |
			| 'Manager'        |
		And I select current line in "List" table
		And in the table "Profiles" I click the button named "ProfilesAdd"
		And I click choice button of "Profile" attribute in "Profiles" table
		And I go to line in "List" table
			| 'Description'         |
			| 'Commercial Agent'    |
		And I select current line in "List" table
		And Delay 1
		And I move to "Users" tab
		And I finish line editing in "Profiles" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 1
		And I go to line in "List" table
			| 'Login'        |
			| 'OWilliams'    |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 1
		And I go to line in "List" table
				| 'Login'      |
				| 'EJones'     |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And I click the button named "FormWriteAndClose"
		And Delay 5


Scenario: _008006 create Partner segments content (employee)
	* Opening the form for filling Partner segments content
		Given I open hyperlink "e1cib/list/Catalog.PartnerSegments"
		And I click the button named "FormCreate"
		And Delay 2
	* Filling in segment information Region 1
		And I change checkbox "Managers"
		And I click Open button of the field named "Description_en"
		And I input "Region 1" text in the field named "Description_en"
		And I input "1 Region" text in the field named "Description_tr"
		And I click "Ok" button
	* Saving and checking the result
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "BanOnShipping" became equal to "No"
			Then the form attribute named "Managers" became equal to "Yes"
			Then the form attribute named "Description_en" became equal to "Region 1"
		And I click the button named "FormWriteAndClose"
		Then I check for the "PartnerSegments" catalog element with the "Description_en" "Region 1" 
	* Filling in segment information Region 2
		And I click the button named "FormCreate"
		And I change checkbox "Managers"
		And I click Open button of the field named "Description_en"
		And I input "Region 2" text in the field named "Description_en"
		And I input "2 Region" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "BanOnShipping" became equal to "No"
			Then the form attribute named "Managers" became equal to "Yes"
			Then the form attribute named "Description_en" became equal to "Region 2"
		And I click the button named "FormWriteAndClose"
		And Delay 3
	* Check for segment creation Region 2
		Then I check for the "PartnerSegments" catalog element with the "Description_en" "Region 2" 


Scenario: _008007 adding employees to the Region 1 and to the Region 2 segment from the form
	* Preparation
		When Create catalog Partners objects (Employee)
		When Create catalog PartnerSegments objects
	* Opening Partners catalog
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.Partners"
	* Adding employees to the Region 1 segment from the form
		* Adding "Olivia Williams" to the segment Region 1
			And I go to line in "List" table
					| 'Description'          |
					| 'Olivia Williams'      |
			And I select current line in "List" table
			And In this window I click command interface button "Partner segments content"
			And I click the button named "FormCreate"
			And I click Select button of "Segment" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Region 1'        |
			And I select current line in "List" table
			And I click "Save and close" button
			* Check data save
				And "List" table became equal
				| 'Segment'     | 'Partner'             |
				| 'Region 1'    | 'Olivia Williams'     |
			And I close all client application windows
			And Delay 2
		* Adding "Emily Jones" to the segment Region 1
			Given I open hyperlink "e1cib/list/Catalog.Partners"
			And I go to line in "List" table
					| 'Description'      |
					| 'Emily Jones'      |
			And I select current line in "List" table
			And Delay 2
			And In this window I click command interface button "Partner segments content"
			And I click the button named "FormCreate"
			And I click Select button of "Segment" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Region 1'        |
			And I select current line in "List" table
			And I click "Save and close" button
			* Check data save
				And "List" table became equal
				| 'Segment'     | 'Partner'         |
				| 'Region 1'    | 'Emily Jones'     |
			And I close all client application windows
			And Delay 2
	* Adding employees to the Region 2 segment from the form
		* Opening Partners catalog
			Given I open hyperlink "e1cib/list/Catalog.Partners"
		*  Adding Olivia Williams to the segment Region 2
			And I go to line in "List" table
					| 'Description'          |
					| 'Olivia Williams'      |
			And I select current line in "List" table
			And In this window I click command interface button "Partner segments content"
			And I click the button named "FormCreate"
			And I click Select button of "Segment" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Region 2'        |
			And I select current line in "List" table
			And I click "Save and close" button
			* Check data save
				And "List" table became equal
				| 'Segment'     | 'Partner'             |
				| 'Region 1'    | 'Olivia Williams'     |
				| 'Region 2'    | 'Olivia Williams'     |
			And I close all client application windows
			And Delay 2
	* Adding employees to the segment Region 1 from the form (the employee also is a client)
		* Opening Partners catalog
			Given I open hyperlink "e1cib/list/Catalog.Partners"
		* Adding Emily Jones to the segment Region 1
			And I go to line in "List" table
					| 'Description'      |
					| 'Emily Jones'      |
			And I select current line in "List" table
			And I change checkbox "Customer"
			And I click the button named "FormWrite"
			And In this window I click command interface button "Partner segments content"
			And I click the button named "FormCreate"
			And I click Select button of "Segment" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Retail'          |
			And I select current line in "List" table
			And I click "Save and close" button
			* Check data save
				And "List" table contains lines
				| 'Segment'     | 'Partner'         |
				| 'Region 1'    | 'Emily Jones'     |
				| 'Retail'      | 'Emily Jones'     |
			And I close all client application windows
	* Adding employees to the segment Region 2 in register
		* Opening register Partner segments content
			Given I open hyperlink "e1cib/list/InformationRegister.PartnerSegments"
		* Adding Sofia Borisova to the segment Region 1
			And I click the button named "FormCreate"
			And I click Select button of "Segment" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Region 1'        |
			And I select current line in "List" table
			Then "Partner segment content (create) *" window is opened
			And I click Select button of "Partner" field
			And Delay 5
			And I go to line in "List" table
				| 'Description'        |
				| 'Sofia Borisova'     |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"
			And "List" table contains lines
				| 'Segment'     | 'Partner'            |
				| 'Region 1'    | 'Sofia Borisova'     |


Scenario: _008008 create employee positions
	And I close all client application windows
	When set True value to the constant Use salary
	* Check hierarchical
		Given I open hyperlink "e1cib/list/Catalog.EmployeePositions"	
		When create Groups in the catalog
	* Create first element
		And I click the button named "FormCreate"
		And I input "Manager" text in "ENG" field
		And I click Open button of "ENG" field
		Then "Edit descriptions" window is opened
		And I input "Manager TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
	* Create first element
		Then "Employee positions" window is opened
		And I click the button named "FormCreate"
		And I input "Sales representative" text in "ENG" field
		And I click "Save and close" button
		And I wait "Expense and revenue type (create) *" window closing in 20 seconds
	* Check creation
		And "List" table contains lines
			| 'Description'             |
			| 'Manager'                 |
			| 'Sales representative'    |
		
Scenario: _008009 create accrual and deduction types
	And I close all client application windows
	* Create first element
		Given I open hyperlink "e1cib/list/Catalog.AccrualAndDeductionTypes"		
		And I click the button named "FormCreate"
		And I input "Salary by day" text in "ENG" field
		And I click Open button of "ENG" field
		Then "Edit descriptions" window is opened
		And I input "Salary by day TR" text in "TR" field
		And I click "Ok" button
		And I select "By day" exact value from the drop-down list named "Periodicity"
		And I select "Accrual" exact value from the drop-down list named "Type"
		And I click Select button of "Expense type" field
		And I click the button named "FormCreate"
		And I input "test expense" text in "ENG" field
		And I select "General expenses" exact value from "Expense type" drop-down list
		And I click "Save and close" button
		And I click the button named "FormChoose"
		And I click "Save and close" button
	* Create second element	
		And I click the button named "FormCreate"
		And I input "Monthly salary" text in "ENG" field
		And I click Open button of "ENG" field
		Then "Edit descriptions" window is opened
		And I input "Monthly salary TR" text in "TR" field
		And I click "Ok" button
		And I select "By period" exact value from the drop-down list named "Periodicity"
		And I select "Accrual" exact value from the drop-down list named "Type"		
		And I click "Save and close" button	
	* Create third element (deduction)
		And I click the button named "FormCreate"
		And I input "Deduction" text in "ENG" field
		And I click Open button of "ENG" field
		Then "Edit descriptions" window is opened
		And I input "Deduction TR" text in "TR" field
		And I click "Ok" button
		And I select "By period" exact value from the drop-down list named "Periodicity"
		And I select "Deduction" exact value from the drop-down list named "Type"		
		And I click "Save and close" button	
	* Create Cash advance deductions
		And I click the button named "FormCreate"
		And I input "Cash advance deductions" text in "ENG" field
		And I click Open button of "ENG" field
		Then "Edit descriptions" window is opened
		And I input "Cash advance deductions TR" text in "TR" field
		And I click "Ok" button
		And I select "By period" exact value from the drop-down list named "Periodicity"
		And I select "Deduction" exact value from the drop-down list named "Type"		
		And I click "Save and close" button		
	* Check creation
		And "List" table contains lines
			| 'Description'                |
			| 'Salary by day'              |
			| 'Monthly salary'             |
			| 'Deduction'                  |
			| 'Cash advance deductions'    |
		And I close all client application windows
		
