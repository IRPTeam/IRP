#language: en
@tree
@IgnoreOnCIMainBuild
@ExportScenarios

Feature: export scenarios

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: set True value to the constant (LC)
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"


Scenario: update tax settings (LC)
	Given I open hyperlink "e1cib/list/Catalog.Taxes"
	And I go to line in "List" table
		| 'Description' |
		| 'VAT' |
	And I select current line in "List" table
	And I click "Settings" button
	And I click "Ok" button
	And I click "Save and close" button
	And I go to line in "List" table
		| 'Description'      |
		| 'SalesTax' |
	And I select current line in "List" table
	And I click "Settings" button
	And I click "Ok" button
	And I click "Save and close" button
	
		


Scenario: add Plugin for tax calculation (LC)
	* Opening a form to add Plugin sessing
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
	* Addition of Plugin sessing for calculating Tax types for Turkey (VAT)
		And I go to line in "List" table
			| 'Description' |
			| 'TaxCalculateVAT_TR'         |
		And I select current line in "List" table
		And I select external file "#workingDir#/DataProcessor/TaxCalculateVAT_TR.epf"
		And I click the button named "FormAddExtDataProc"
		And I input "" text in "Path to plugin for test" field
		And I input "TaxCalculateVAT_TR" text in "Name" field
		And I click Open button of the field named "Description_en"
		And I input "TaxCalculateVAT_TR" text in the field named "Description_en"
		And I input "TaxCalculateVAT_TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And I wait "Plugins (create)" window closing in 10 seconds
	* Check added processing
		Then I check for the "ExternalDataProc" catalog element with the "Description_en" "TaxCalculateVAT_TR"
		Given I open hyperlink "e1cib/list/Catalog.Taxes"		
		And I go to line in "List" table
			| 'Description' |
			| 'VAT'         |
		And I select current line in "List" table
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description' |
			| 'TaxCalculateVAT_TR'         |
		And I select current line in "List" table
		And I click "Save and close" button
	And I close all client application windows

Scenario: update ItemKeys (LC)
	Given I open hyperlink "e1cib/list/Catalog.ItemKeys"
	And I click "Update item keys description" button
	And Delay 5
	And I close all client application windows
