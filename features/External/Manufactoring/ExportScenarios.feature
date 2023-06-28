#language: en
@tree
@IgnoreOnCIMainBuild
@ExportScenarios

Feature: export scenarios


Background:
	Given I open new TestClient session or connect the existing one


Scenario: change interface localization code for CI
	Given I open hyperlink "e1cib/list/Catalog.Users"
	If "Users" catalog element with "Description_en" equal to "CI" does not exist Then
		And I go to line in "List" table
			| 'Login'    |
			| 'CI'       |
		And I select current line in "List" table
		And I select "Russian" exact value from "Data localization" drop-down list
		And I click Open button of the field named "Description_en"
		And I input "CI" text in the field named "Description_en"
		And I input "CI" text in the field named "Description_ru"
		And I input "CI" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button

Scenario: change interface localization code for CI (en)
	Given I open hyperlink "e1cib/list/Catalog.Users"
	And I go to line in "List" table
		| 'Login'   |
		| 'CI'      |
	And I select current line in "List" table
	And I select "English" exact value from "Data localization" drop-down list
	And I click Open button of the field named "Description_ru"
	And I input "CI" text in the field named "Description_en"
	And I input "CI" text in the field named "Description_ru"
	And I input "CI" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save and close" button




Scenario: filling in user settings (manufactoring)
	Given I open hyperlink "e1cib/list/InformationRegister.UserSettings"
	* For Document.Production
		* Company
			And I click the button named "FormCreate"
			And I click Select button of "User or group" field
			And I go to line in "" table
				| ''         |
				| 'User'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Login'     |
				| 'CI'        |
			And I select current line in "List" table
			And I input "Document.Production" text in "Metadata object" field
			And I input "Company" text in "Attribute name" field
			And I select "Regular" exact value from "Kind of attribute" drop-down list
			And I click Select button of "Value" field
			And I go to line in "" table
				| ''            |
				| 'Company'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"
		* BusinessUnit
			And I click the button named "FormCreate"
			And I click Select button of "User or group" field
			And I go to line in "" table
				| ''         |
				| 'User'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Login'     |
				| 'CI'        |
			And I select current line in "List" table
			And I input "Document.Production" text in "Metadata object" field
			And I input "BusinessUnit" text in "Attribute name" field
			And I select "Regular" exact value from "Kind of attribute" drop-down list
			And I click Select button of "Value" field
			And I go to line in "" table
				| ''                  |
				| 'Business unit'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'               |
				| 'Склад производства 04'     |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"
		* StoreProduction
			And I click the button named "FormCreate"
			And I click Select button of "User or group" field
			And I go to line in "" table
				| ''         |
				| 'User'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Login'     |
				| 'CI'        |
			And I select current line in "List" table
			And I input "Document.Production" text in "Metadata object" field
			And I input "StoreProduction" text in "Attribute name" field
			And I select "Regular" exact value from "Kind of attribute" drop-down list
			And I click Select button of "Value" field
			And I go to line in "" table
				| ''          |
				| 'Store'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"
	* For Document.ProductionPlanning
		* Company
			And I click the button named "FormCreate"
			And I click Select button of "User or group" field
			And I go to line in "" table
				| ''         |
				| 'User'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Login'     |
				| 'CI'        |
			And I select current line in "List" table
			And I input "Document.ProductionPlanning" text in "Metadata object" field
			And I input "Company" text in "Attribute name" field
			And I select "Regular" exact value from "Kind of attribute" drop-down list
			And I click Select button of "Value" field
			And I go to line in "" table
				| ''            |
				| 'Company'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"
		* BusinessUnit
			And I click the button named "FormCreate"
			And I click Select button of "User or group" field
			And I go to line in "" table
				| ''         |
				| 'User'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Login'     |
				| 'CI'        |
			And I select current line in "List" table
			And I input "Document.ProductionPlanning" text in "Metadata object" field
			And I input "BusinessUnit" text in "Attribute name" field
			And I select "Regular" exact value from "Kind of attribute" drop-down list
			And I click Select button of "Value" field
			And I go to line in "" table
				| ''                  |
				| 'Business unit'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'               |
				| 'Склад производства 04'     |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"
	* For Document.ProductionPlanningCorrection
		* Company
			And I click the button named "FormCreate"
			And I click Select button of "User or group" field
			And I go to line in "" table
				| ''         |
				| 'User'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Login'     |
				| 'CI'        |
			And I select current line in "List" table
			And I input "Document.ProductionPlanningCorrection" text in "Metadata object" field
			And I input "Company" text in "Attribute name" field
			And I select "Regular" exact value from "Kind of attribute" drop-down list
			And I click Select button of "Value" field
			And I go to line in "" table
				| ''            |
				| 'Company'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"
		* BusinessUnit
			And I click the button named "FormCreate"
			And I click Select button of "User or group" field
			And I go to line in "" table
				| ''         |
				| 'User'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Login'     |
				| 'CI'        |
			And I select current line in "List" table
			And I input "Document.ProductionPlanningCorrection" text in "Metadata object" field
			And I input "BusinessUnit" text in "Attribute name" field
			And I select "Regular" exact value from "Kind of attribute" drop-down list
			And I click Select button of "Value" field
			And I go to line in "" table
				| ''                  |
				| 'Business unit'     |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'               |
				| 'Склад производства 04'     |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"
		

