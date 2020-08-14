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

Scenario: _010007 adding additional details for partners "Business region"
	* Opening a form for adding additional attributes for partners
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data item name |
			| Catalog_Partners          |
		And I select current line in "List" table
	* Filling in the name of the settings for adding additional details for partners
		And I click Open button of the field named "Description_en"
		And I input "Partners" text in the field named "Description_en"
		And I input "Partners TR" text in the field named "Description_tr"
		And I click "Ok" button
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
	* Adding additional attribute Business region
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Business region" text in the field named "Description_en"
		And I input "Business region TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "BusinessRegion" text in "Unique ID" field
		And I click "Save and close" button
		And Delay 5
		And I click the button named "FormChoose"
	* Create an UI group for additional attribute
		And I activate "UI group" field in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Main information" text in the field named "Description_en"
		And I input "Main information TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I change "Form position" radio button value to "Left"
		And I click "Save and close" button
		And Delay 5
		And I click the button named "FormChoose"
		And I finish line editing in "Attributes" table
		And I click "Save and close" button
		And Delay 5
		And I close all client application windows
	* Filling in the created additional attribute for partners
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click Select button of "Business region" field
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Region Turkey" text in the field named "Description_en"
		And I input "Turkey TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Region Ukraine" text in the field named "Description_en"
		And I input "Ukraine TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
		And I go to line in "List" table
			| Description |
			| Region Ukraine     |
		And I click the button named "FormChoose"
		And I click "Save and close" button
		And Delay 2
		And I go to line in "List" table
			| Description |
			| Lomaniti   |
		And I select current line in "List" table
		And I click Select button of "Business region" field
		And I go to line in "List" table
			| Description |
			| Region Ukraine     |
		And I click the button named "FormChoose"
		And I click "Save and close" button
		And Delay 2
		And I go to line in "List" table
			| Description |
			| Kalipso   |
		And I select current line in "List" table
		And I click Select button of "Business region" field
		And I go to line in "List" table
			| Description |
			| Region Ukraine     |
		And I click the button named "FormChoose"
		And I click "Save and close" button
		And Delay 2
		And I click "List" button
		And I go to line in "List" table
			| Description |
			| Alians   |
		And I select current line in "List" table
		And I click Select button of "Business region" field
		And I go to line in "List" table
			| Description |
			| Region Turkey     |
		And I click the button named "FormChoose"
		And I click "Save and close" button
		And Delay 2
		And I go to line in "List" table
			| Description |
			| MIO   |
		And I select current line in "List" table
		And I click Select button of "Business region" field
		And I go to line in "List" table
			| Description |
			| Region Turkey     |
		And I click the button named "FormChoose"
		And I click "Save and close" button
		And Delay 2


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