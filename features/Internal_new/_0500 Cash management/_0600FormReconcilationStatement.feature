#language: en
@tree
@Positive
@CashManagement

Feature: form Reconcilation statement

As an accountant
I want to create a Reconcilation statement
For reconciliation of settlements

Background:
	Given I launch TestClient opening script or connect the existing one




Scenario: _060004 check that the Reconcilation statement document is connected to the status system
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Creating statuses for the document Reconciliation Statement
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
		And I go to line in "List" table
			| 'Code'    |
			| 'Objects statuses'|
		And I expand current line in "List" table
		And I go to line in "List" table
			| Predefined data item name |
			| ReconciliationStatement                |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Reconciliation statement" text in the field named "Description_en"
		And I input "Reconciliation statement TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
		* Adding status "Send"
			And I go to line in "List" table
			| 'Description'              |
			| 'Reconciliation statement' |
			And I click the button named "FormCreate"
			And I set checkbox "Set by default"
			And I click Open button of the field named "Description_en"
			And I input "Send" text in the field named "Description_en"
			And I input "Send TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And Delay 2
		* Adding status "Approved"
			And I go to line in "List" table
			| 'Description'              |
			| 'Reconciliation statement' |
			And I click the button named "FormCreate"
			And I click Open button of the field named "Description_en"
			And I input "Approved" text in the field named "Description_en"
			And I input "Approved TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And Delay 2
	* Check if they are filled out in the document Reconciliation Statement
		Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
		And I click the button named "FormCreate"
		Then the form attribute named "Status" became equal to "Send"
		And I select "Approved" exact value from "Status" drop-down list
		And I close all client application windows

Scenario: _060005 availability of Currency, Begin and End period field in Reconcilation statement
	Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
	And I click the button named "FormCreate"
	And I click Select button of "Currency" field
	And I go to line in "List" table
		| 'Code' | 'Description'  |
		| 'TRY'  | 'Turkish lira' |
	And I select current line in "List" table
	And I click Select button of "Begin period" field
	And I input "01.09.2019" text in "Begin period" field
	And I input "30.09.2019" text in "End period" field
	And the editing text of form attribute named "BeginPeriod" became equal to "01.09.2019"
	And the editing text of form attribute named "EndPeriod" became equal to "30.09.2019"
	Then the form attribute named "Currency" became equal to "TRY"









	
