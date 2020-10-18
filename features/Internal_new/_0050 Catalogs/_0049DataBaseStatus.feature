#language: en
@tree
@Positive
@Catalogs

Feature: filling in data base title

As an owner
I want to fill out items information
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"



Scenario: _0050 Data base title
	And I close all client application windows
	* Filling in title
		Given I open hyperlink "e1cib/list/Catalog.DataBaseStatus"
		And I click the button named "FormCreate"
		And I input "Test IRP" text in the field named "Description_en"
		And I click "Save and close" button
	* Check Data base title
		And I close all client application windows
		And I close TestClient session
		Then I connect launched Test client "Этот клиент"
		And I delete "$$DataBaseTitle0050$$" variable
		And I save the window as "$$DataBaseTitle0050$$"
		And I display "$$DataBaseTitle0050$$" variable value
		Then "$$DataBaseTitle0050$$" variable is equal to "Test IRP"
	And I close all client application windows	