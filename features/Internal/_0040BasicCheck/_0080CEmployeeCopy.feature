#language: en
@tree
@Positive
@Test3
@Group1


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
