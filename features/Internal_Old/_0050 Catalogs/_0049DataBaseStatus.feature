#language: en
@tree
@Positive
@SettingsCatalogs

Feature: filling in data base title

As an owner
I want to fill out items information
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one



Scenario: _0050 Data base title
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Filling in title
		Given I open hyperlink "e1cib/list/Catalog.DataBaseStatus"
		And I go to line in "List" table
			| 'is Product server' |
			| 'Yes'               | 
		And I select current line in "List" table	
		And I input "Test IRP" text in the field named "Description_en"
		And I click "Save and close" button
	* Check Data base title
		And I close all client application windows
		And I close TestClient session
		Given I open new TestClient session or connect the existing one
		And I delete "$$$$DataBaseTitle0050$$$$" variable
		And I save the window as "$$$$DataBaseTitle0050$$$$"
		And I display "$$$$DataBaseTitle0050$$$$" variable value
		Then "$$$$DataBaseTitle0050$$$$" variable is equal to "Test IRP"
	And I close all client application windows	