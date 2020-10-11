#language: en
@ee
@Positive
@Other

Feature: password check



Background:
Given I launch TestClient opening script or connect the existing one


Scenario: _351000 preparation
        When Create catalog Users objects
        When Create catalog AccessProfiles objects
        When Create catalog AccessGroups objects
        
        
                                        

Scenario: _351001 check user password setting from enterprise mode
        And I close all client application windows
        * Select user
                        Given I open hyperlink "e1cib/list/Catalog.Users"
                        And I go to line in "List" table
                                | 'Description'                 |
                                | 'Arina Brown (Financier 3)' |
                        And I select current line in "List" table
                * Change localization code
                        And I input "en" text in "Interface localization code" field	
                        And I click "Save" button
        * Set password
                        And I click "Set password" button
                        And I input "F12345" text in "Password" field
                        * Check message output if password confirmation does not match
                                And I input "F12346" text in "Confirm password" field
                                And I click "Ok" button
                                Then I wait that in user messages the "Password and password confirmation do not match." substring will appear in "30" seconds
                        * Password enty is correct
                                And I input "" text in "Confirm password" field
                                And I input "F12345" text in "Confirm password" field
                                And I click "Ok" button
                                And I click "Save and close" button
                                And Delay 10
                Given I open hyperlink "e1cib/list/Catalog.AccessProfiles"
                And I go to line in "List" table
                                | 'Description' |
                                | 'Financier'   |
                And I select current line in "List" table
                And in the table "Roles" I click "Update roles" button
                And I go to line in "Roles" table
                        | 'Presentation'    |
                        | 'Run thin client' |
                And I set "Use" checkbox in "Roles" table
                And I finish line editing in "Roles" table
                And I go to line in "Roles" table
                        | 'Presentation'   |
                        | 'Run web client' |
                And I set "Use" checkbox in "Roles" table
                And I finish line editing in "Roles" table
                And I go to line in "Roles" table
                        | 'Presentation' |
                        | 'Full access'  |
                And I set "Use" checkbox in "Roles" table
                And I finish line editing in "Roles" table
                And I click "Save and close" button
        * Verify password set
                        And I connect "Test" TestClient using "ABrown" login and "F12345" password
                        And Delay 3
                        When in sections panel I select "Sales - A/R"
                        And I close TestClient session
                        Then I connect launched Test client "Этот клиент"

Scenario: _351002 check user password generation from enterprise mode
        * Select user
                Given I open hyperlink "e1cib/list/Catalog.Users"
                And I go to line in "List" table
                | 'Description'                 |
                | 'Arina Brown (Financier 3)' |
                And I select current line in "List" table
        * Set password
                And I click "Set password" button
                And I click "Generate" button
                And I save the value of the field named "GeneratedValue" as "password"
                And I click "Ok" button
                And I click "Save and close" button
                And Delay 10
        * Verify password set
                And I connect "Test" TestClient using "ABrown" login and "$password$" password
                And Delay 3
                When in sections panel I select "Sales - A/R"
                And I close TestClient session
                Then I connect launched Test client "Этот клиент"
                
Scenario: _999999 close TestClient session
        And I close TestClient session