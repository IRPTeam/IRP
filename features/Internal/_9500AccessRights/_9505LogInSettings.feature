#language: en
@tree
@Positive
@AccessRights

Feature: change roles for user


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: 950500 preparation
	Then I connect launched Test client "Этот клиент"
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
		
Scenario: 9505001 check preparation
	When check preparation
	

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
	If sections panel contains "Treasury" command Then
		When in sections panel I select "Treasury"
	If sections panel contains "Finans" command Then
		When in sections panel I select "Finans"
	And I close TestClient session	
	Then I connect launched Test client "Этот клиент"
	Given I open hyperlink 'e1cib/list/Catalog.Users'
	And "List" table does not contain lines
		| 'Login'       |
		| 'SBorisova' |
	And "List" table contains lines
		| 'Login'       |
		| 'BorisovaS' |
		
Scenario: 950510 check disable user
		And I connect launched Test client "Этот клиент"
		And I close all client application windows	
	* Disable user
		Given I open hyperlink 'e1cib/list/Catalog.Users'
		And I go to line in "List" table
			| 'Description'       |
			| 'David Romanov (Financier 1)' |
		And I select current line in "List" table
		And I move to "Roles" tab
		And "RoleList" table contains lines
			| 'Value'           |
			| 'Run thin client' |
			| 'Run web client'  |
			| 'Full access'     |
			| 'Basic role'      |
		And I set checkbox named "Disable"
		And I click "Save and close" button
		And I wait "David Romanov (Financier 1) (User) *" window closing in 20 seconds
	* Check
		When I Check the steps for Exception
			|'And I connect "DRomanov" TestClient using "DRomanov" login and "" password'|
	* Enable user
		And I connect launched Test client "Этот клиент"
		Given I open hyperlink 'e1cib/list/Catalog.Users'
		And I go to line in "List" table
			| 'Description'       |
			| 'David Romanov (Financier 1)' |
		And I select current line in "List" table
		Then the form attribute named "Disable" became equal to "Yes"
		And I remove checkbox named "Disable"
		And I move to "Roles" tab
		And "RoleList" table contains lines
			| 'Value'           |
			| 'Run thin client' |
			| 'Run web client'  |
			| 'Full access'     |
			| 'Basic role'      |
		And I click "Save and close" button
		And I wait "David Romanov (Financier 1) (User) *" window closing in 20 seconds
	* Check
		And I connect "DRomanov" TestClient using "DRomanov" login and "" password
		And I close TestClient session
				



	
