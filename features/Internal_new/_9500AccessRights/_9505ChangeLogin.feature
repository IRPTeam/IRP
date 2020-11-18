#language: en
@tree
@Positive
@AccessRights

Feature: change roles for user


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: 950300 preparation
	* Check test user roles
		Given I open hyperlink 'e1cib/list/Catalog.Users'
		And I go to line in "List" table
			| 'Description'       |
			| 'Sofia Borisova (Manager 3)' |
		And I select current line in "List" table
		And I move to "Roles" tab
		And "RoleList" table contains lines
			| 'Value'                 |
			| 'Basic role'            |
			| 'Run mobile client'     |
			| 'Run thin client'       |
			| 'Run web client'        |
			| 'Full access only read' |
		And I close all client application windows
		

	

Scenario: 950503 change login and check access
	Given I open hyperlink 'e1cib/list/Catalog.Users'
	And I go to line in "List" table
		| 'Description'       |
		| 'Sofia Borisova (Manager 3)' |
	And I select current line in "List" table
	And I input "BorisovaS" text in "Login" field
	And I click "Save and close" button	
	And I connect "BorisovaS" TestClient using "BorisovaS" login and "F12345" password
	And Delay 3
	When in sections panel I select "Treasury"
	And I close TestClient session	
	Then I connect launched Test client "Этот клиент"
	Given I open hyperlink 'e1cib/list/Catalog.Users'
	And "List" table does not contain lines
		| 'Login'       |
		| 'SBorisova' |
	And "List" table contains lines
		| 'Login'       |
		| 'BorisovaS' |
	And I close TestClient session
		
	

	
