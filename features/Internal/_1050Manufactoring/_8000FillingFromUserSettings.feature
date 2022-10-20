#language: en
@tree
@SettingsFilters

Feature: filling in from user settings

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"



Background:
	Given I open new TestClient session or connect the existing one



Scenario: _8000 preparation (filling in from user settings)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When change interface localization code for CI
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	Then I connect launched Test client "Этот клиент"
	When Create catalog Companies objects (Main company)
	When Create catalog BusinessUnits objects (MF)
	When Create catalog Stores objects
	When filling in user settings (manufactoring)


			

Scenario: _8012 check filling in field from custom user settings in Production
	Given I open hyperlink "e1cib/list/Document.Production"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "BusinessUnit" became equal to "Склад производства 04"
		Then the form attribute named "StoreProduction" became equal to "Store 02"
	And I close all client application windows

Scenario: _8013 check filling in field from custom user settings in ProductionPlanning
	Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "BusinessUnit" became equal to "Склад производства 04"
	And I close all client application windows

Scenario: _8014 check filling in field from custom user settings in ProductionPlanningCorrection
	Given I open hyperlink "e1cib/list/Document.ProductionPlanningCorrection"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "BusinessUnit" became equal to "Склад производства 04"
	And I close all client application windows

