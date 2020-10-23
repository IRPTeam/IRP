#language: en
@tree
@Positive
@Other
@ExtensionReportForm

Feature: add extension



Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _4000100 preparation
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Constants
		When set True value to the constant
	* Load info
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create information register Barcodes records


Scenario: _4000101 add extension
	Given I open hyperlink "e1cib/list/Catalog.Extensions"
	And I click the button named "FormCreate"
	And I select external file "#workingDir#\DataProcessor\TestExtension.cfe"
	And I click "Add file" button
	And I input "TestExtension" text in "Description" field
	And I click the button named "FormWriteAndClose"
	And I close TestClient session
	And I install the "TestExtension" extension
	Given I open new TestClient session or connect the existing one


Scenario: _4000105 check add atributes from extensions
	Given I open hyperlink "e1cib/list/Catalog.Currencies"
	And I click the button named "FormCreate"
	And the field named "REP_Attribute1" exists on the form
	And I close all client application windows
	


	
	
		