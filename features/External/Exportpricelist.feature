#language: en
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Feature: export scenarios

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: finishing adding a line to the price list
	And I finish line editing in "ItemList" table
	And in the table "ItemList" I click "Add" button
	And I click choice button of "Item key" attribute in "ItemList" table

Scenario: changing the price list number
	And I input "0" text in "Number" field
	Then "1C:Enterprise" window is opened
	And I click "Yes" button
	Then "Price list (create) *" window is opened

Scenario: open the form to create a price list
	Given I open hyperlink "e1cib/list/Document.PriceList"
	And Delay 2
	And I click the button named "FormCreate"
	And Delay 2