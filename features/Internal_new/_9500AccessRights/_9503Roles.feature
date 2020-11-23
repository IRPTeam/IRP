#language: en
@tree
@Positive
@AccessRights

Feature: change roles for user


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: 950300 preparation
	Then I connect launched Test client "Этот клиент"
	* Check test user roles
		Given I open hyperlink 'e1cib/list/Catalog.Users'
		And I go to line in "List" table
			| 'Description'       |
			| 'Alexander Orlov (Commercial Agent 2)' |
		And I select current line in "List" table
		And I move to "Roles" tab
		Then the number of "RoleList" table lines is "равно" 0
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'       |
			| 'Anna Petrova (Commercial Agent 3)' |
		And I select current line in "List" table
		And I move to "Roles" tab
		Then the number of "RoleList" table lines is "равно" 0
		And I click "Save and close" button
		And I close all client application windows
		


Scenario: 950303 check adding user in the access group with several profiles (role combination)
	* Add test user to the Run client AccessGroup
		Given I open hyperlink 'e1cib/list/Catalog.AccessGroups'
		And I go to line in "List" table
			| 'Description'       |
			| 'Run client+Basic role' |
		And I select current line in "List" table
		And I move to "Users" tab
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And I go to line in "List" table
			| 'Description'                          |
			| 'Anna Petrova (Commercial Agent 3)' |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And I click "Save and close" button
	* Check role combination for user
		Given I open hyperlink 'e1cib/list/Catalog.Users'
		And I go to line in "List" table
			| 'Description'       |
			| 'Anna Petrova (Commercial Agent 3)' |
		And I select current line in "List" table
		And I move to "Roles" tab
		And "RoleList" table contains lines
			| 'Value'             |
			| 'Run mobile client' |
			| 'Run thick client'  |
			| 'Run thin client'   |
			| 'Run web client'    |
			| 'Basic role'        |
		Then the number of "RoleList" table lines is "равно" 5
		And I close current window
	* Delete profile Run client Run client from access group Run client+Basic role and check roles combination update
		Given I open hyperlink 'e1cib/list/Catalog.AccessGroups'
		And I go to line in "List" table
			| 'Description'       |
			| 'Run client+Basic role' |
		And I select current line in "List" table
		And I go to line in "Profiles" table
			| 'Profile'                          |
			| 'Run client' |
		And in the table "Profiles" I click the button named "ProfilesContextMenuDelete"
		And I click "Save and close" button
		Given I open hyperlink 'e1cib/list/Catalog.Users'
		And I go to line in "List" table
			| 'Description'       |
			| 'Anna Petrova (Commercial Agent 3)' |
		And I select current line in "List" table
		And I move to "Roles" tab
		And "RoleList" table contains lines
			| 'Value'             |
			| 'Basic role'        |
		Then the number of "RoleList" table lines is "равно" 1
		And I close current window
	* Add profile Run client Run client back to the access group Run client+Basic role and check roles combination update
		Given I open hyperlink 'e1cib/list/Catalog.AccessGroups'
		And I go to line in "List" table
			| 'Description'       |
			| 'Run client+Basic role' |
		And I select current line in "List" table
		And in the table "Profiles" I click the button named "ProfilesAdd"
		And I click choice button of "Profile" attribute in "Profiles" table
		And I go to line in "List" table
			| 'Description'                          |
			| 'Run client' |
		And I select current line in "List" table
		And I finish line editing in "Profiles" table
		And I click "Save and close" button
		Given I open hyperlink 'e1cib/list/Catalog.Users'
		And I go to line in "List" table
			| 'Description'       |
			| 'Anna Petrova (Commercial Agent 3)' |
		And I select current line in "List" table
		And I move to "Roles" tab
		And "RoleList" table contains lines
			| 'Value'             |
			| 'Run mobile client' |
			| 'Run thick client'  |
			| 'Run thin client'   |
			| 'Run web client'    |
			| 'Basic role'        |
		Then the number of "RoleList" table lines is "равно" 5
		And I close current window



Scenario: 950310 check adding user in several Access group (role combination)
	* Add test user to the Run client AccessGroup
		Given I open hyperlink 'e1cib/list/Catalog.AccessGroups'
		And I go to line in "List" table
			| 'Description'       |
			| 'Run client' |
		And I select current line in "List" table
		And I move to "Users" tab
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And I go to line in "List" table
			| 'Description'                          |
			| 'Alexander Orlov (Commercial Agent 2)' |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And I click "Save and close" button
	* Add test user to the Basic role AccessGroup
		And I go to line in "List" table
			| 'Description'       |
			| 'Basic role' |
		And I select current line in "List" table
		And I move to "Users" tab
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And I go to line in "List" table
			| 'Description'                          |
			| 'Alexander Orlov (Commercial Agent 2)' |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And I click "Save and close" button
	* Check role combination for user
		Given I open hyperlink 'e1cib/list/Catalog.Users'
		And I go to line in "List" table
			| 'Description'       |
			| 'Alexander Orlov (Commercial Agent 2)' |
		And I select current line in "List" table
		And I move to "Roles" tab
		And "RoleList" table contains lines
			| 'Value'             |
			| 'Run mobile client' |
			| 'Run thick client'  |
			| 'Run thin client'   |
			| 'Run web client'    |
			| 'Basic role'        |
		Then the number of "RoleList" table lines is "равно" 5
		And I close current window
	* Delete user from Run client access group and check roles combination update
		Given I open hyperlink 'e1cib/list/Catalog.AccessGroups'
		And I go to line in "List" table
			| 'Description'       |
			| 'Run client' |
		And I select current line in "List" table
		And I move to "Users" tab
		And I go to line in "Users" table
			| 'User'                          |
			| 'Alexander Orlov (Commercial Agent 2)' |
		And in the table "Users" I click the button named "UsersContextMenuDelete"
		And I click "Save and close" button
		Given I open hyperlink 'e1cib/list/Catalog.Users'
		And I go to line in "List" table
			| 'Description'       |
			| 'Alexander Orlov (Commercial Agent 2)' |
		And I select current line in "List" table
		And I move to "Roles" tab
		And "RoleList" table contains lines
			| 'Value'             |
			| 'Basic role'        |
		Then the number of "RoleList" table lines is "равно" 1
		And I close current window
	* Add user back to the Run client access group and check roles combination update
		Given I open hyperlink 'e1cib/list/Catalog.AccessGroups'
		And I go to line in "List" table
			| 'Description'       |
			| 'Run client' |
		And I select current line in "List" table
		And I move to "Users" tab
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And I go to line in "List" table
			| 'Description'                          |
			| 'Alexander Orlov (Commercial Agent 2)' |
		And I select current line in "List" table
		And I finish line editing in "Users" table
		And I click "Save and close" button
		Given I open hyperlink 'e1cib/list/Catalog.Users'
		And I go to line in "List" table
			| 'Description'       |
			| 'Alexander Orlov (Commercial Agent 2)' |
		And I select current line in "List" table
		And I move to "Roles" tab
		And "RoleList" table contains lines
			| 'Value'             |
			| 'Run mobile client' |
			| 'Run thick client'  |
			| 'Run thin client'   |
			| 'Run web client'    |
			| 'Basic role'        |
		Then the number of "RoleList" table lines is "равно" 5
		And I close current window
		
				
				

	
