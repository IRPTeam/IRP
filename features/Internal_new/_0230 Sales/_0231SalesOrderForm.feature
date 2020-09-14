#language: en
@tree
@Positive
@Group5
Feature: Sales order document form


As a sales manager
I want the Sales order document form convenient
For fast data entry


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _023101 displaying in the Sales order only available valid Partner terms for the selected customer
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And "List" table became equal
		| 'Description'                   |
		| 'Basic Partner terms, TRY'         |
		| 'Basic Partner terms, $'           |
		| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And "List" table became equal
		| 'Description'            |
		| 'Basic Partner terms, TRY'         |
		| 'Basic Partner terms, $'           |
		| 'Basic Partner terms, without VAT' |
		| 'Personal Partner terms, $' |
	And I close current window
	And I close current window
	And I click "No" button
	* Check that expired Partner terms are not displayed in the selection list
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I go to line in "List" table
		| 'Description'           |
		| 'Basic Partner terms, $' |
		And I select current line in "List" table
		And I input "02.11.2018" text in "End of use" field
		And I click "Save and close" button
		And I close current window
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And "List" table became equal
			| 'Description'                   |
			| 'Basic Partner terms, TRY'         |
			| 'Basic Partner terms, without VAT' |
		And I close current window
		And I close current window
		And I click "No" button
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, $' |
		And I select current line in "List" table
		And I input "02.11.2019" text in "End of use" field
		And I click "Save and close" button
		And I close current window

Scenario: _023102 select only your own companies in the Company field
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description' |
		| 'Ferron BP'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'           |
		| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	And I click Select button of "Company" field
	And "List" table became equal
		| 'Description'  |
		| 'Main Company' |
	And I close current window
	And I close current window
	And I click "No" button

Scenario: _023103 filling in Company field from the Partner term
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'           |
		| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	Then the form attribute named "Company" became equal to "Main Company"
	And I close current window
	And I click "No" button


Scenario: _023104 filling in Store field from the Partner term
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'       |
		| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	Then the form attribute named "Store" became equal to "Store 02"
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'       |
		| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	Then the form attribute named "Store" became equal to "Store 01"
	And I close current window
	And I click "No" button

Scenario: _023105 check that the Account field is missing from the order
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And field "Account" is not present on the form


Scenario: _023106 check the form of selection of items (sales order)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'       |
				| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| 'Description' |
				| 'Company Ferron BP'  |
		And I select current line in "List" table
	When check the product selection form with price information in Sales order
	And in the table "ItemList" I click "% Offers" button
	And in the table "Offers" I click the button named "FormOK"
	And I click "Post and close" button
	* Check Sales order Saving
		And "List" table contains lines
		| 'Currency'  | 'Partner'     | 'Status'   | 'Σ'         |
		| 'TRY'       | 'Ferron BP'   | 'Approved' | '2 050,00'  |
	And I close all client application windows




Scenario: _023113 check totals in the document Sales order
	* Open list form Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
	* Select Sales order
		And I go to line in "List" table
		| Number |
		| 1      |
		And I select current line in "List" table
	* Check for document results
		Then the form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "3 686,44"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "663,56"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "4 350,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"

