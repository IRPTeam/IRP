#language: en
@tree
@Positive
@Catalogs

Feature: filling in Payment types catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one



Scenario: _005027 filling in the "Payment types" catalog  
	* Opening a form and creating Payment types
		Given I open hyperlink "e1cib/list/Catalog.PaymentTypes"
		When create a catalog element with the name Test
		And I close current window
	* Check for created Payment types
		Then I check for the "PaymentTypes" catalog element with the "Description_en" "Test ENG"  
		Then I check for the "PaymentTypes" catalog element with the "Description_tr" "Test TR"