#language: en
@tree
@Positive
@TaxSettings
@CompanyCatalogs

Feature: filling in tax rates

As an owner
I want to filling in tax rates
For tax accounting


Variables:
import "Variables.feature"

Background:
	Given I open new TestClient session or connect the existing one


Scenario: _017902 filling in catalog 'Tax types'
		When set True value to the constant
	* Preparation
		When Create catalog TaxRates objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
	* Opening a tax creation form
		Given I open hyperlink "e1cib/list/Catalog.Taxes"
		And I click the button named "FormCreate"
	* Filling VAT settings
		And I input "VAT" text in the field named "Description_en"
		And I select "VAT" exact value from the drop-down list named "Kind"		
		And in the table "TaxRates" I click the button named "TaxRatesAdd"
		And I click choice button of "Tax rate" attribute in "TaxRates" table
		And I go to line in "List" table
			| 'Description'    |
			| '8%'             |
		And I select current line in "List" table
		And I finish line editing in "TaxRates" table
		And in the table "TaxRates" I click the button named "TaxRatesAdd"
		And I click choice button of "Tax rate" attribute in "TaxRates" table
		And I go to line in "List" table
			| 'Description'   |
			| '18%'           |
		And I select current line in "List" table
		And I finish line editing in "TaxRates" table
		And in the table "TaxRates" I click the button named "TaxRatesAdd"
		And I click choice button of "Tax rate" attribute in "TaxRates" table
		And I go to line in "List" table
			| 'Description'   |
			| '0%'            |
		And I select current line in "List" table
		And I finish line editing in "TaxRates" table
		And in the table "TaxRates" I click the button named "TaxRatesAdd"
		And I click choice button of "Tax rate" attribute in "TaxRates" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Without VAT'    |
		And I select current line in "List" table
		And I move to "Use documents" tab
		And I finish line editing in "TaxRates" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Sales order" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Sales invoice" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Purchase order" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Purchase invoice" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Cash expense" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Cash revenue" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Purchase return" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Purchase return order" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Sales return order" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Sales return" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Bank receipt" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Cash receipt" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Bank payment" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Cash payment" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And I click "Save" button
		And In this window I click command interface button "Tax rate settings"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I input "01.10.2019" text in "Period" field
		And I select "18%" exact value from "Tax rate" drop-down list
		And I click "Save and close" button
		And I close all client application windows
	* Check the creation of Taxes catalog elements
		Then I check for the "Taxes" catalog element with the "Description_en" "VAT"








