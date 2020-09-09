#language: en
@tree
@Positive


Feature: filling in customer contact information

As an owner
I want there to be a mechanism for entering customer contact information
To specify: address, phone, e-mail, gps coordinate on the map


Background:
	Given I open new TestClient session or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"

   


Scenario: _010005 create company for Partners (Ferron, Kalipso, Lomaniti)
	* Preparation
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Countries objects
	* Opening the form for filling in Company
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I click the button named "FormCreate"
		And Delay 2
	* Filling in company data 'Company Ferron BP'
		And I click Open button of the field named "Description_en"
		And I input "Company Ferron BP" text in the field named "Description_en"
		And I input "Company Ferron BP TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "Turkey" text in "Country" field
		And I input "Ferron BP" text in "Partner" field
		And I select "Company" exact value from the drop-down list named "Type"
		And I click "Save" button
		* Check data save
		And I click "Save and close" button
	* Check the availability of the created company  "Company Ferron BP"
		Then I check for the "Companies" catalog element with the "Description_en" "Company Ferron BP" 
		Then I check for the "Companies" catalog element with the "Description_tr" "Company Ferron BP TR"
	* Creating "Company Kalipso"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Company Kalipso" text in the field named "Description_en"
		And I input "Company Kalipso TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "Ukraine" text in "Country" field
		And I input "Kalipso" text in "Partner" field
		And I select "Company" exact value from the drop-down list named "Type"
		And I click "Save" button
		* Check data save
		And I click "Save and close" button
		Then I check for the "Companies" catalog element with the "Description_en" "Company Kalipso" 
		Then I check for the "Companies" catalog element with the "Description_tr" "Company Kalipso TR" 
	


Scenario: _010006 create a structure of partners (partners), 1 main partner and several subordinates
	* Opening the form for filling in partners
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click the button named "FormCreate"
		And Delay 2
	* Creating partners: 'Alians', 'MIO', 'Seven Brand'
		And I click Open button of the field named "Description_en"
		And I input "Alians" text in the field named "Description_en"
		And I input "Alians TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I change checkbox "Customer"
		And I click "Save and close" button
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "MIO" text in the field named "Description_en"
		And I input "MIO TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I change checkbox "Customer"
		And I click "Save and close" button
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Seven Brand" text in the field named "Description_en"
		And I input "Seven Brand TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I change checkbox "Customer"
		And I click "Save and close" button
		And Delay 5
	* Check for created partners: 'Alians', 'MIO', 'Seven Brand'
		Then I check for the "Partners" catalog element with the "Description_en" "Alians" 
		Then I check for the "Partners" catalog element with the "Description_en" "MIO"
		Then I check for the "Partners" catalog element with the "Description_en" "Seven Brand" 
	* Subordination of partners 'Alians', 'MIO' to the main partner 'Seven Brand'
		And I go to line in "List" table
			| 'Description' |
			| 'Alians'  |
		And I select current line in "List" table
		And I click Select button of "Main partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Seven Brand'  |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to "Seven Brand"
		And I click "Save and close" button
		And Delay 5
		Then "Partners" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'MIO'  |
		And I select current line in "List" table
		And I click Select button of "Main partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Seven Brand'  |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to "Seven Brand"
		And I click "Save and close" button
		And Delay 5
	* Structure check
		And I click "Hierarchical list" button
		And "List" table does not contain lines
			| 'Description' |
			| 'MIO' |
			| 'Alians'  |
		And I go to line in "List" table
			| 'Description' |
			| 'Seven Brand'  |
		And I move one level down in "List" table
		And "List" table became equal
			| 'Description' |
			| 'Seven Brand' |
			| 'Alians' |
			| 'MIO' |

		
Scenario: _010008 create of a partner structure (Partners), 1 main partner, under which a 2nd level partner and under which 2 3rd level partners
	* Opening the catalog Partners
		Given I open hyperlink "e1cib/list/Catalog.Partners"
	* Filling in the "Seven Brand" partner Kalipso as the main partner
		And I go to line in "List" table
			| 'Description' |
			| 'Seven Brand'  |
		And I select current line in "List" table
		And I click Select button of "Main partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'  |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to "Kalipso"
		And I click "Save and close" button
		And Delay 5
	* Check the subordination of "Seven Brand" (together with the "Alians" and "MIO" subordinates) to Kalipso partner
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click "Hierarchical list" button
		And "List" table contains lines
			| 'Description' |
			| 'Kalipso' |
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'  |
		And I move one level down in "List" table
		And I move one level down in "List" table
		And "List" table became equal
			| 'Description' |
			| 'Kalipso' |
			| 'Alians' |
			| 'MIO' |