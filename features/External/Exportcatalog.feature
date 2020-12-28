
#language: en
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Feature: export scenarios

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: create a catalog element with the name Test
	And Delay 2
	And I click the button named "FormCreate"
	And Delay 2
	And I click Open button of the field named "Description_en"
	And I input "Test ENG" text in the field named "Description_en"
	And I input "Test TR" text in the field named "Description_tr"
	And I click "Ok" button
	And I click the button named "FormWrite"
	And Delay 5


Scenario: create setting to download the course (Forex Seling)
	* Creating a setting to download the Forex Seling course (tcmb.gov.tr)
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "Forex Seling" text in "Description" field
		And I input "ForexSeling" text in "Unique ID" field
		And I click "Save" button
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description'    |
			| 'ExternalTCMBGovTr' |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 10
