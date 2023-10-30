#language: en
@tree
@Positive
@AccessRightsSystem

Feature: access rights system accumulation and information registers


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: 960001 preparation (access rights system registers)
	And I connect "Этот клиент" TestClient using "CI" login and "CI" password
	When set True value to the constant
	When set True value to the constant Use commission trading
	When set True value to the constant Use accounting
	When set True value to the constant Use consolidated retail sales
	When set True value to the constant Use object access
	When set True value to the constant Use salary
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When Create catalog Users and AccessProfiles objects (LimitedAccess)
	Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
	And I go to line in "List" table
		| 'Description'          |
		| 'Unit access group'    |
	And I select current line in "List" table	
	If "Profiles" table does not contain lines Then
		| 'Profile'      |
		| 'Unit profile' |
		And in the table "Profiles" I click "Add" button
		And I click choice button of "Profile" attribute in "Profiles" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Unit profile'    |
		And I select current line in "List" table
		And I move to "Users" tab
		And I finish line editing in "Profiles" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And I go to line in "List" table
			| 'Description'   |
			| 'LimitedAccess' |
		And I select current line in "List" table
		And I finish line editing in "Users" table
	* Check ObjectAccess table
		And "ObjectAccess" table became equal
			| '#'  | 'Key'       | 'Value ref'                         | 'Modify' | 'Do not control' |
			| '1'  | 'Company'   | 'Company Read and Write Access'     | 'Yes'    | 'No'             |
			| '2'  | 'Company'   | 'Company Only read access'          | 'No'     | 'No'             |
			| '3'  | 'Branch'    | 'Branch Read and Write Access'      | 'Yes'    | 'No'             |
			| '4'  | 'Branch'    | 'Branch Only read access'           | 'No'     | 'No'             |
			| '5'  | 'Store'     | 'Store Read and Write Access'       | 'Yes'    | 'No'             |
			| '6'  | 'Store'     | 'Store Only read access'            | 'No'     | 'No'             |
			| '7'  | 'Account'   | 'CashAccount Read and Write Access' | 'Yes'    | 'No'             |
			| '8'  | 'Account'   | 'CashAccount Only read access'      | 'No'     | 'No'             |
			| '9'  | 'PriceType' | 'PriceType Read and Write Access'   | 'Yes'    | 'No'             |
			| '10' | 'PriceType' | 'PriceType Only read access'        | 'No'     | 'No'             |
	And I click "Save and close" button
	And I connect "TestAdmin" TestClient using "LimitedAccess" login and "" password
	When import data for access rights
	And I close all client application windows

Scenario: 963002 try post SO (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrder"


