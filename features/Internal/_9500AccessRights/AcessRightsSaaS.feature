# #language: en

# @tree
# @Positive
# @AccessRights

# Functionality: admin acess rights in SaaS mode

# Background:
# 	Given I launch TestClient opening script or connect the existing one


# Scenario: preparation
# 	And I set "True" value to the constant "SaasMode"
# 	And I close TestClient session
# 	Given I open new TestClient session or connect the existing one
# 	* Create area 
# 		Given I open hyperlink "e1cib/list/Catalog.DataAreas"
# 		And I click the button named "FormCreate"
# 		And I input "Area 01" text in "Description" field
# 		And I input "##Login##" text in "Login" field
# 		And I input "##Password##" text in "Password" field
# 		And I select "English" exact value from "Localization" drop-down list
# 		And I select "English" exact value from "Interface" drop-down list
# 		And I input "0" text in "Code" field
# 		Then "1C:Enterprise" window is opened
# 		And I click "Yes" button
# 		And I input "1" text in "Code" field
# 		And I click "Save and close" button
# 		And I click "Update areas" button
# 		And Delay 30
		
				

# Scenario: create Admin for SaaS without Full access rights
# 	* Login in the Area 01
# 		Given I open hyperlink "e1cib/list/Catalog.DataAreas"
# 		And I go to line in "List" table
# 			| 'Description' | 'Data area status' |
# 			| 'Area 01'     | 'Working' |
# 		And I click "Login to area" button
# 	* Check roles for first user in the area
# 		Given I open hyperlink "e1cib/list/Catalog.Users"
# 		And I go to line in "List" table
# 			| 'Description' | 'Login' |
# 			| 'CI'     | 'CI' |
# 		And I select current line in "List" table
# 		And I move to "Roles" tab
# 		And "RoleList" table contains lines
# 			| 'Value'               |
# 			| 'Full access in area' |
# 			| 'Run thin client'     |
# 			| 'Run web client'      |
# 		Then the number of "RoleList" table lines is "равно" "3"
# 		And I close all client application windows
# 	* Open Test client user CI from Area
# 		// And I connect "TestAdminArea" TestClient using "CI" login and "##Password##" password
# 		And I connect "TestAdminArea" TestClient using "CI" login and "8HRUYXL2UC" password