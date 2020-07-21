
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