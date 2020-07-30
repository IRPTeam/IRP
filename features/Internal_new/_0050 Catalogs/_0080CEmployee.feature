#language: en
@tree
@Positive
@Test

Feature: access rights

As an owner
I want to create users
To restrict user access rights

Background:
	Given I open new TestClient session or connect the existing one



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
		And I input "Даниэль Смит (Торговый агент 1)" text in the field named "Description_ru"
		And I click "Ok" button
		And I input "DSmith" text in "Login" field
		And I input "en" text in "Localization code" field
		And I input "en" text in "Interface localization code" field
		And I set checkbox named "ShowInList"
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
		And I input "en" text in "Localization code" field
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
		And I input "en" text in "Interface localization code" field
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
	* Check for created elements
		Then I check for the "Users" catalog element with the "Description_en" "Daniel Smith (Commercial Agent 1)"
		Then I check for the "Users" catalog element with the "Description_tr" "Daniel Smith (Commercial Agent 1) TR"
		Then I check for the "Users" catalog element with the "Description_ru" "Даниэль Смит (Торговый агент 1)"
		And Delay 5
		Then I check for the "Users" catalog element with the "Description_en" "Olivia Williams (Manager 1)"  
		Then I check for the "Users" catalog element with the "Description_en" "Emily Jones (Manager 2)"
		Then I check for the "Users" catalog element with the "Sofia Borisova (Manager 3)"
		



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


