#language: en
@tree
@Positive
@Test
@Group01
@Catalogs

Feature: filling in Special offers catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"


Scenario: _005031 filling in the "Special offers" catalog
	* Opening a form and creating Special offers: Special Price
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Special Price" text in the field named "Description_en"
		And I input "Special Price TR" text in the field named "Description_tr"
		And I input "Специальная цена" text in the field named "Description_ru"
		And I click "Ok" button
		And I click Select button of "Special offer type" field
		And I click the button named "FormCreate"
		And I click Select button of "Plugins" field
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Special Price" text in the field named "Description_en"
		And I input "Special Price" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "Special Price" text in the field named "Name"
		And I click the button named "FormWriteAndClose"
		And I wait "Plugins (create)" window closing in 20 seconds
		And I click the button named "FormChoose"
		And I click Open button of the field named "Description_en"
		And I input "Special Price" text in the field named "Description_en"
		And I input "Special Price" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 2
		And I click the button named "FormChoose"
		And I input "2" text in the field named "Priority"
		And I input "03.12.2018  0:00:00" text in the field named "StartOf"
		And I input "05.12.2018  0:00:00" text in the field named "EndOf"
		And I select "Sales" exact value from "Document type" drop-down list
		And I set checkbox named "Manually"
		And I set checkbox named "Launch"
		And I click the button named "FormWriteAndClose"
		And Delay 2
	* Check creation
		Then I check for the "SpecialOffers" catalog element with the "Description_en" "Special Price"  
		Then I check for the "SpecialOffers" catalog element with the "Description_tr" "Special Price TR"
		Then I check for the "SpecialOffers" catalog element with the "Description_ru" "Специальная цена"