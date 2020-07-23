#language: en
@tree
@Positive
@Test

Feature: access rights

As an owner
I want to create groups, User access profiles and users
To restrict user access rights

Background:
	Given I open new TestClient session or connect the existing one


Scenario: _008001 adding employees to the Partners catalog
	* Opening the form for filling in Partners
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And Delay 2
	* Creating test partners for employees: Alexander Orlov, Anna Petrova, David Romanov, Arina Brown
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Alexander Orlov" text in the field named "Description_en"
		And I input "Alexander Orlov TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Employee"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Anna Petrova" text in the field named "Description_en"
		And I input "Anna Petrova TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Employee"
		And I click the button named "FormWriteAndClose"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "David Romanov" text in the field named "Description_en"
		And I input "David Romanov TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Employee"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Arina Brown" text in the field named "Description_en"
		And I input "Arina Brown TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "Employee"
		And I click the button named "FormWriteAndClose"
	* Check for created elements
		Then I check for the "Partners" catalog element with the "Description_en" "Alexander Orlov"
		Then I check for the "Partners" catalog element with the "Description_en" "Anna Petrova"
		And Delay 2
		Then I check for the "Partners" catalog element with the "Description_en" "David Romanov"
		And Delay 2
		Then I check for the "Partners" catalog element with the "Description_en" "Arina Brown"




Scenario: _008002 User access groups creation
	* Opening the form for filling in User access groups
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
	* Access group creation Commercial Agent
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Commercial Agent" text in the field named "Description_en"
		And I input "Commercial Agent TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Access group creation "Manager"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Manager" text in the field named "Description_en"
		And I input "Manager TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Access group creation "Administrators"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Administrators" text in the field named "Description_en"
		And I input "Administrators TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Access group creation "Financier"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Financier" text in the field named "Description_en"
		And I input "Financier TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Check for created elements
		Then I check for the "AccessGroups" catalog element with the "Description_en" "Commercial Agent"  
		Then I check for the "AccessGroups" catalog element with the "Description_tr" "Commercial Agent TR"
		Then I check for the "AccessGroups" catalog element with the "Description_en" "Manager"  
		Then I check for the "AccessGroups" catalog element with the "Description_en" "Administrators"  
		Then I check for the "AccessGroups" catalog element with the "Description_en" "Financier" 

Scenario: _008003 User access profiles creation
	* Opening the form for filling in profiles
		Given I open hyperlink "e1cib/list/Catalog.AccessProfiles"
		And Delay 2
	* User access profiles creation Commercial Agent
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Commercial Agent" text in the field named "Description_en"
		And I input "Commercial Agent TR" text in the field named "Description_tr"
		And I click "Ok" button
		And in the table "Roles" I click "Update roles" button
		* Set up access for the Commercial Agent
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'      | 'Use' |
				| 'IRP'           | 'Run mobile client' | 'No'  |
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
				| 'Configuration' | 'Presentation' | 'Use' |
				| 'IRP'           | 'Basic role'   | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I click the button named "FormWriteAndClose"
			And I wait "User access profiles (create)" window closing in 20 seconds
			And Delay 5
	* User access profiles creation Manager
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Manager" text in the field named "Description_en"
		And I input "Manager TR" text in the field named "Description_tr"
		And I click "Ok" button
		And in the table "Roles" I click "Update roles" button
		* Set up access for the Manager
			And I go to line in "Roles" table
				| 'Configuration' | 'Presentation'     | 'Use' |
				| 'IRP'           | 'Run thick client' | 'No'  |
			And I change "Use" checkbox in "Roles" table
			And I finish line editing in "Roles" table
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
		And I click the button named "FormWriteAndClose"
		And I wait "User access profiles (create)" window closing in 20 seconds
	* User access profiles creation Financier
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Financier" text in the field named "Description_en"
		And I input "Financier TR" text in the field named "Description_tr"
		And I click "Ok" button
		And in the table "Roles" I click "Update roles" button
		* Set up access for the Financier
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
		And I wait "User access profiles (create)" window closing in 20 seconds
	* User access profiles creation Administrators
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Administrators" text in the field named "Description_en"
		And I input "Administrators TR" text in the field named "Description_tr"
		And I click "Ok" button
		And in the table "Roles" I click "Update roles" button
		Set up access for admin
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
	* Check for created elements
		Then I check for the "AccessProfiles" catalog element with the "Description_en" "Commercial Agent"  
		Then I check for the "AccessProfiles" catalog element with the "Description_en" "Manager"  
		Then I check for the "AccessProfiles" catalog element with the "Description_en" "Financier"  
		Then I check for the "AccessProfiles" catalog element with the "Description_en" "Administrators"  



Scenario: _008004 filling in the "Users" catalog 
	* Opening the form for filling in users
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
	* User creation Commercial Agent 1
		And I click Open button of the field named "Description_en"
		And I input "Daniel Smith (Commercial Agent 1)" text in the field named "Description_en"
		And I input "Daniel Smith (Commercial Agent 1) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "DSmith" text in "Login" field
		And I input "EN" text in "Localization code" field
		And I input "en" text in "Interface localization code" field
		And I set checkbox named "ShowInList"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* User creation Commercial Agent 2
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Alexander Orlov (Commercial Agent 2)" text in the field named "Description_en"
		And I input "Alexander Orlov (Commercial Agent 2) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "AOrlov" text in "Login" field
		And I input "tr" text in "Localization code" field
		And I input "tr" text in "Interface localization code" field
		And I set checkbox named "ShowInList"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Alexander Orlov |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* User creation Commercial Agent 3
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Anna Petrova (Commercial Agent 3)" text in the field named "Description_en"
		And I input "Anna Petrova (Commercial Agent 3) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "APetrova" text in "Login" field
		And I input "tr" text in "Localization code" field
		And I input "tr" text in "Interface localization code" field
		And I set checkbox named "ShowInList"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Anna Petrova |
		And I select current line in "List" table
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
		And I input "tr" text in "Localization code" field
		And I input "tr" text in "Interface localization code" field
		And I set checkbox named "ShowInList"
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
		And I input "tr" text in "Localization code" field
		And I input "tr" text in "Interface localization code" field
		And I set checkbox named "ShowInList"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* User creation Manager 3
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Sofia Borisova (Manager 3)" text in the field named "Description_en"
		And I input "Sofia Borisova (Manager 3) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "SBorisova" text in "Login" field
		And I input "tr" text in "Localization code" field
		And I input "tr" text in "Interface localization code" field
		And I set checkbox named "ShowInList"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* User creation Financier 1
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "David Romanov (Financier 1)" text in the field named "Description_en"
		And I input "David Romanov (Financier 1) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "DRomanov" text in "Login" field
		And I input "tr" text in "Localization code" field
		And I input "tr" text in "Interface localization code" field
		And I set checkbox named "ShowInList"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| David Romanov |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
	* User creation Financier 2
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Ella Zelenova (Financier 2)" text in the field named "Description_en"
		And I input "Ella Zelenova (Financier 2) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "EZelenova" text in "Login" field
		And I input "tr" text in "Localization code" field
		And I input "tr" text in "Interface localization code" field
		And I set checkbox named "ShowInList"
		And I click the button named "FormWriteAndClose"
	* User creation Financier 3
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Arina Brown (Financier 3)" text in the field named "Description_en"
		And I input "Arina Brown (Financier 3)TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "ABrown" text in "Login" field
		And I input "tr" text in "Localization code" field
		And I input "tr" text in "Interface localization code" field
		And I set checkbox named "ShowInList"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Arina Brown |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
	* Check for created elements
		Then I check for the "Users" catalog element with the "Description_en" "Daniel Smith (Commercial Agent 1)"
		Then I check for the "Users" catalog element with the "Description_en" "Alexander Orlov (Commercial Agent 2)"  
		Then I check for the "Users" catalog element with the "Description_en" "Anna Petrova (Commercial Agent 3)"
		And Delay 1
		Then I check for the "Users" catalog element with the "Description_en" "Olivia Williams (Manager 1)"
		Then I check for the "Users" catalog element with the "Description_en" "Emily Jones (Manager 2)"
		And Delay 1
		Then I check for the "Users" catalog element with the "Description_en" "Sofia Borisova (Manager 3)"
		Then I check for the "Users" catalog element with the "Description_en" "David Romanov (Financier 1)"
		Then I check for the "Users" catalog element with the "Description_en" "Ella Zelenova (Financier 2)"
		And Delay 1
		Then I check for the "Users" catalog element with the "Description_en" "Arina Brown (Financier 3)"


Scenario: _008005 assignment of access rights to users
	* Opening the User access groups catalog
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
	* Assignment of access rights to sales rep
		And I go to line in "List" table
				| 'Description' |
				| 'Commercial Agent'       |
		And I select current line in "List" table
		And in the table "Profiles" I click the button named "ProfilesAdd"
		And I click choice button of "Profile" attribute in "Profiles" table
		And I go to line in "List" table
				| 'Description' |
				| 'Commercial Agent'       |
		And I select current line in "List" table
		And Delay 1
		And I move to "Users" tab
		And I finish line editing in "Profiles" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 3
		And I activate "Users" window
		And I go to line in "List" table
			| 'Login'  |
			| 'DSmith' |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 1
		And I go to line in "List" table
			| 'Login' |
			| 'AOrlov'       |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 1
		And I go to line in "List" table
			| 'Login' |
			| 'APetrova'       |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Assignment of access rights to managers
		And I go to line in "List" table
			| 'Description' |
			| 'Manager'       |
		And I select current line in "List" table
		And in the table "Profiles" I click the button named "ProfilesAdd"
		And I click choice button of "Profile" attribute in "Profiles" table
		And I go to line in "List" table
			| 'Description' |
			| 'Commercial Agent'       |
		And I select current line in "List" table
		And Delay 1
		And I move to "Users" tab
		And I finish line editing in "Profiles" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 1
		And I go to line in "List" table
			| 'Login' |
			| 'OWilliams'       |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 1
		And I go to line in "List" table
				| 'Login' |
				| 'EJones'       |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 1
		And I go to line in "List" table
				| 'Login' |
				| 'SBorisova'       |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Assignment of access rights to financiers
		And I go to line in "List" table
				| 'Description' |
				| 'Financier'       |
		And I select current line in "List" table
		And in the table "Profiles" I click the button named "ProfilesAdd"
		And I click choice button of "Profile" attribute in "Profiles" table
		And I go to line in "List" table
				| 'Description' |
				| 'Financier'       |
		And I select current line in "List" table
		And Delay 1
		And I move to "Users" tab
		And I finish line editing in "Profiles" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 1
		And I go to line in "List" table
				| 'Login' |
				| 'DRomanov'       |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 1
		And I go to line in "List" table
				| 'Login' |
				| 'EZelenova'       |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 1
		And I go to line in "List" table
				| 'Login' |
				| 'ABrown'       |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And I click the button named "FormWriteAndClose"
	* Adding a user with administrator access (Turkish localization)
		And I go to line in "List" table
				| 'Description' |
				| 'Administrators'       |
		And I select current line in "List" table
		And in the table "Profiles" I click the button named "ProfilesAdd"
		And I click choice button of "Profile" attribute in "Profiles" table
		And I go to line in "List" table
				| 'Description' |
				| 'Administrators'       |
		And I select current line in "List" table
		And Delay 1
		And I move to "Users" tab
		And I finish line editing in "Profiles" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And Delay 1
		And I go to line in "List" table
				| 'Login' |
				| 'ABrown'       |
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
		And I click the button named "FormWriteAndClose"
		And Delay 10
		Then I check for the "PartnerSegments" catalog element with the "Description_en" "Region 1" 
	* Filling in segment information Region 2
		And I click the button named "FormCreate"
		And I change checkbox "Managers"
		And I click Open button of the field named "Description_en"
		And I input "Region 2" text in the field named "Description_en"
		And I input "2 Region" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 10
	* Check for segment creation Region 2
		Then I check for the "PartnerSegments" catalog element with the "Description_en" "Region 2" 


Scenario: _008007 adding employees to the Region 1 (A+B) segment from the form
	* Opening Partners catalog
		Given I open hyperlink "e1cib/list/Catalog.Partners"
	* Adding "Alexander Orlov" to the segment Region 1
		And I go to line in "List" table
				| 'Description'  |
				| 'Alexander Orlov' |
		And I select current line in "List" table
		And Delay 2
		And I click Select button of "Manager segment" field
		And Delay 2
		And I go to line in "List" table
				| 'Description'  |
				| 'Region 1' |
		And I select current line in "List" table
		And Delay 2
		And I click the button named "FormWriteAndClose"
		And Delay 2
	* Adding "Anna Petrova" to the segment Region 1
		And I go to line in "List" table
				| 'Description'  |
				| 'Anna Petrova' |
		And I select current line in "List" table
		And Delay 2
		And I click Select button of "Manager segment" field
		And Delay 2
		And I go to line in "List" table
				| 'Description'  |
				| 'Region 1' |
		And I select current line in "List" table
		And Delay 2
		And I click the button named "FormWriteAndClose"
		And Delay 2

Scenario: _008008 adding employees to the Region 2 (A) segment from the form
	* Opening Partners catalog
		Given I open hyperlink "e1cib/list/Catalog.Partners"
	*  Adding Alexander Orlov to the segment Region 2
		And I go to line in "List" table
				| 'Description'  |
				| 'Alexander Orlov' |
		And I select current line in "List" table
		And Delay 2
		And I click Select button of "Manager segment" field
		And Delay 2
		And I go to line in "List" table
				| 'Description'  |
				| 'Region 2' |
		And I select current line in "List" table
		And Delay 2
		And I click the button named "FormWriteAndClose"
		And Delay 5


Scenario: _008009 adding employees to the segment Region 1 from the form (the employee also is a client)
	* Opening Partners catalog
		Given I open hyperlink "e1cib/list/Catalog.Partners"
	* Adding Anna Petrova to the segment Region 1
		And I go to line in "List" table
				| 'Description'  |
				| 'Anna Petrova' |
		And I select current line in "List" table
		And Delay 2
		And I change checkbox "Customer"
		And I click the button named "FormWriteAndClose"
		And I go to line in "List" table
				| 'Description'  |
				| 'Anna Petrova' |
		And I select current line in "List" table
		And Delay 2
		And I click Select button of "Manager segment" field
		And Delay 2
		And I go to line in "List" table
				| 'Description'  |
				| 'Region 1' |
		And I select current line in "List" table
		And Delay 2
		And I click the button named "FormWriteAndClose"
		And Delay 5



Scenario: _008010 addition of employees to the segment Region 2 (C) in register
	* Opening register Partner segments content
		Given I open hyperlink "e1cib/list/InformationRegister.PartnerSegments"
	* Adding David Romanov to the segment Region 1
		And I click the button named "FormCreate"
		And Delay 2
		And I click Select button of "Segment" field
		And Delay 2
		And I go to line in "List" table
			| 'Description' |
			| 'Region 1'  |
		And I select current line in "List" table
		Then "Partner segments content (create) *" window is opened
		And I click Select button of "Partner" field
		And Delay 5
		And I go to line in "List" table
			| 'Description'  |
			| 'David Romanov' |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And "List" table contains lines
			| Segment | Partner |
			| Region 1 | David Romanov |


