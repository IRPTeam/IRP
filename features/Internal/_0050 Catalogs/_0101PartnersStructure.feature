#language: en
@tree
@Positive
@PartnerCatalogs

Feature: filling in customer contact information

As an owner
I want there to be a mechanism for entering customer contact information
To specify: address, phone, e-mail, gps coordinate on the map


Background:
	Given I open new TestClient session or connect the existing one


   


Scenario: _010005 create company for Partners (Ferron, Kalipso, Lomaniti)
	When set True value to the constant
	When Create information register UserSettings records (DisableAutomaticCreationOfCompanyAndAgreementForPartner - False)
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
		* Check data save (dublicate desctiprion)
		And I click "Save and close" button
		Then there are lines in TestClient message log
			|'Description not unique [Company Ferron BP]'|
		* Change Description_en and try save
			And I input "Company Ferron BP1" text in "ENG" field
			And I click "Save and close" button
			Then there are lines in TestClient message log
				|'Description not unique [Company Ferron BP]'|
		* Change Description_tr and try save
			And I click Open button of the field named "Description_en"
			And I input "Company Ferron BP1 TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And Delay 2
	* Check the availability of the created company  "Company Ferron BP"
		Then I check for the "Companies" catalog element with the "Description_en" "Company Ferron BP1" 
		Then I check for the "Companies" catalog element with the "Description_tr" "Company Ferron BP1 TR"
	* Creating "Company Kalipso"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Company Kalipso1" text in the field named "Description_en"
		And I input "Company Kalipso1 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "Ukraine" text in "Country" field
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso1'       |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I click "Save" button
		* Check data save
		And I click "Save and close" button
		Then I check for the "Companies" catalog element with the "Description_en" "Company Kalipso1" 
		Then I check for the "Companies" catalog element with the "Description_tr" "Company Kalipso1 TR" 
	And I close TestClient session
	Given I open new TestClient session or connect the existing one 
	


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
			| 'Description'    |
			| 'Alians'         |
		And I select current line in "List" table
		And I click Select button of "Main partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Seven Brand'    |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to "Seven Brand"
		And I click "Save and close" button
		And Delay 5
		Then "Partners" window is opened
		And I go to line in "List" table
			| 'Description'     |
			| 'MIO'             |
		And I select current line in "List" table
		And I click Select button of "Main partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Seven Brand'     |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to "Seven Brand"
		And I click "Save and close" button
		And Delay 5
	* Structure check
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click "Hierarchical list" button
		And "List" table does not contain lines
			| 'Description'    |
			| 'MIO'            |
			| 'Alians'         |
		And I go to line in "List" table
			| 'Description'    |
			| 'Seven Brand'    |
		And I move one level down in "List" table
		And "List" table contains lines
			| 'Description'    |
			| 'Seven Brand'    |
			| 'Alians'         |
			| 'MIO'            |
		Then the number of "List" table lines is "равно" "3"

		
Scenario: _010008 create of a partner structure (Partners), 1 main partner, under which a 2nd level partner and under which 2 3rd level partners
	* Opening the catalog Partners
		Given I open hyperlink "e1cib/list/Catalog.Partners"
	* Filling in the "Seven Brand" partner Kalipso as the main partner
		And I go to line in "List" table
			| 'Description'    |
			| 'Seven Brand'    |
		And I select current line in "List" table
		And I click Select button of "Main partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso1'        |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to "Kalipso1"
		And I click "Save and close" button
		And Delay 5
	* Check the subordination of "Seven Brand" (together with the "Alians" and "MIO" subordinates) to Kalipso partner
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click "Hierarchical list" button
		And "List" table contains lines
			| 'Description'    |
			| 'Kalipso1'        |
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso1'        |
		And I move one level down in "List" table
		And I move one level down in "List" table
		And "List" table contains lines
			| 'Description'    |
			| 'Kalipso1'        |
			| 'Alians'         |
			| 'MIO'            |
		Then the number of "List" table lines is "равно" "3"

Scenario: _010009 check filling legal name in the partner term (complex partner structure)
		And I close all client application windows
		When Create information register UserSettings records (DisableAutomaticCreationOfCompanyAndAgreementForPartner - True)
	* Create one more legal name for MIO
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'    |
			| 'MIO'            |
		And I select current line in "List" table
		And In this window I click command interface button "Company"
		And I click the button named "FormCreate"
		And I input "MIO" text in "ENG" field
		And I select "Company" exact value from the drop-down list named "Type"
		And I click "Save and close" button
		And I wait "Company (create) *" window closing in 5 seconds
	* Check filling legal name in the partner term from partner
		And In this window I click command interface button "Partner terms"
		And I click "Create" button
		And I click Select button of "Legal name" field
		And "List" table became equal
			| 'Description'    |
			| 'MIO'            |
		And I go to line in "List" table
			| 'Description'    |
			| 'MIO'            |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "MIO"
		And I close current window
		And I click "No" button			
	* Mark for deletion legal name and check filling legal name from main partner
		And In this window I click command interface button "Company"		
		And I go to line in "List" table
			| 'Description'    |
			| 'MIO'            |
		And in the table "List" I click "Mark for deletion / Unmark for deletion" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And In this window I click command interface button "Partner terms"
		And I click "Create" button
		And I click Select button of "Legal name" field
		And "List" table contains lines
			| 'Description'        |
			| 'Company Kalipso1'   |
		And "List" table does not contain lines
			| 'Description'    |
			| 'MIO'            |
		And I go to line in "List" table
			| 'Description'        |
			| 'Company Kalipso1'   |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company Kalipso1"
		And I close all client application windows

Scenario: _010010 check auto create Legal name and Company and Partner term
	And I close all client application windows
	* Preparation
		When Create information register UserSettings records (DisableAutomaticCreationOfCompanyAndAgreementForPartner - False)
	* Create Partner (customer and vendor)
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click the button named "FormCreate"
		And I input "Test partner 11" text in "ENG" field
		And I input "7899789980900" text in "Tax ID" field
		And I set checkbox named "Vendor"
		And I set checkbox named "Customer"
	* Move to company
		And In this window I click command interface button "Company"
		* Question about saving data
			Then "1C:Enterprise" window is opened
			And I click "OK" button
		* Question about create New Legal name
			* Yes
				Then "1C:Enterprise" window is opened
				And I click "Yes" button
		* Check legal name
			And "List" table became equal
				| 'Description'     |
				| 'Test partner 11' |
			And I go to line in "List" table
				| 'Description'        |
				| 'Test partner 11'   |
			And I select current line in "List" table
			Then the form attribute named "Description_en" became equal to "Test partner 11"
			Then the form attribute named "Partner" became equal to "Test partner 11"
			Then the form attribute named "Type" became equal to "Company"
			Then the form attribute named "TaxID" became equal to "7899789980900"
			And I close current window
	* Move to partner term
		And In this window I click command interface button "Partner terms"
		* Question about create New Partner term
			* Yes
				Then "1C:Enterprise" window is opened
				And I click "Yes" button
		* Check partner term
			And form attributes have values:
				| 'Name'                            | 'Value'                   | 'HowToSearch' |
				| 'ApArPostingDetail'               | "By agreements"           | ''            |
				| 'Kind'                            | "Regular"                 | ''            |
				| 'LegalName'                       | "Test partner 11"         | ''            |
				| 'Partner'                         | "Test partner 11"         | ''            |
				| 'PriceType'                       | "en description is empty" | ''            |
			And I close "Partner term (create)" window
			And In this window I click command interface button "Company"
			And In this window I click command interface button "Partner terms"
			When I Check the steps for Exception
				| 'Then "1C:Enterprise" window is opened'     |
		And I close all client application windows
	

Scenario: _010011 check auto create Legal name and Company and Partner term
	And I close all client application windows
	* Preparation
		When Create information register UserSettings records (DisableAutomaticCreationOfCompanyAndAgreementForPartner - False)
	* Create Partner (customer and vendor)
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click the button named "FormCreate"
		And I input "Test partner 12" text in "ENG" field
		And I input "7899789980901" text in "Tax ID" field
		And I set checkbox named "Vendor"
		And I set checkbox named "Customer"
	* Move to company
		And In this window I click command interface button "Company"
		* Question about saving data
			Then "1C:Enterprise" window is opened
			And I click "OK" button
		* Question about create New Legal name
			* No
				Then "1C:Enterprise" window is opened
				And I click "No" button
		* Check
			Then the number of "List" table lines is "равно" 0
	* Move to Partner term
		And In this window I click command interface button "Partner terms"
		* Question about create New Partner terms
			* No
				Then "1C:Enterprise" window is opened
				And I click "No" button
		* Check
			Then the number of "List" table lines is "равно" 0			
	And I close all client application windows