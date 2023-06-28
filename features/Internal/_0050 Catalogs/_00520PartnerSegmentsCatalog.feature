#language: en
@tree
@Positive
@PartnerCatalogs

Feature: filling in Partner segments catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one




Scenario: _005023 filling in the "Partner segments content" catalog
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Opening the form for filling in Partner segments content
		Given I open hyperlink "e1cib/list/Catalog.PartnerSegments"
	* Create segments: Distribution
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Distribution" text in the field named "Description_en"
		And I input "Distribution TR" text in the field named "Description_tr"
		And I input "Дистрибьюция" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Check for created Partner segments content
		Then I check for the "PartnerSegments" catalog element with the "Description_tr" "Distribution TR"
		Then I check for the "PartnerSegments" catalog element with the "Description_en" "Distribution" 
		Then I check for the "PartnerSegments" catalog element with the "Description_ru" "Дистрибьюция"
	# * Clean catalog PartnerSegments
	# 	And I delete "PartnerSegments" catalog element with the Description_en "Distribution"
