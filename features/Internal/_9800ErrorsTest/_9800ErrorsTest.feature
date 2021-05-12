#language: en
@tree
@ErrorsTest

Feature: errors test


Background:
	Given I open new TestClient session or connect the existing one

Scenario: _9800 preparation (errors test)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When update ItemKeys
		
Scenario: _9801 filling user settings for Sales order
	Given I open hyperlink "e1cib/list/Catalog.Users"
	And I go to line in "List" table
		| 'Login' |
		| 'CI'          |
	And I select current line in "List" table
	And I input "CI" text in the field named "Description_en"
	And I select "English" exact value from "Interface localization" drop-down list
	And I click "Save" button
	And I click "User settings" button
	* Fill in custom settings for Sales order
		And I go to line in "MetadataTree" table
		| 'Group name'  |
		| 'Sales order' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Partner term'  | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		And I activate "Use" field in "MetadataTree" table
		And I change "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	And I click "Ok" button
	And I click "Save and close" button


Scenario: _9802 create document SI based on Sales order
	When create SalesOrder023001
	* Check filling in SI
		And I select current line in "ListTable" table
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table became equal
			| '#' | 'Business unit'           | 'Price type'        | 'Item'     | 'Item key'  | 'Dont calculate row' | 'Serial lot numbers' | 'Q'      | 'Unit' | 'Tax amount' | 'Price'  | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order'                             | 'Revenue type' |
			| '1' | 'Distribution department' | 'Basic Price Types' | 'Dress'    | 'L/Green'   | 'No'                 | ''                   | '10,000' | 'pcs'  | ''           | '550,00' | ''              | '2 750,00'   | '2 750,00'     | ''                    | 'Store 01' | '12.03.2021'    | 'No'                        | '123'    | 'Sales order 1 dated 12.03.2021 19:07:17' | 'Revenue'      |
			| '2' | 'Distribution department' | 'Basic Price Types' | 'Trousers' | '36/Yellow' | 'No'                 | ''                   | '4,000'  | 'pcs'  | ''           | '400,00' | ''              | '1 600,00'   | '1 600,00'     | ''                    | 'Store 01' | '12.03.2021'    | 'No'                        | ''       | 'Sales order 1 dated 12.03.2021 19:07:17' | 'Revenue'      |
		And I close all client application windows
		
Scenario: _9803 check barcode
	And I execute 1C:Enterprise script
		 | "BarcodeClient.InputBarcodeEnd(123, 123)" |

Scenario: _9804 check Purchase subsystem
	When in sections panel I select "Purchase"


Scenario: _9805 check partner, legal name, Partner term, company and store input by search in line in a document Retail sales receipt (in english)
	And I close all client application windows
	* Open a creation form Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "TRY" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"


Scenario: _9806 check Sales subsystem
	When in sections panel I select "Sales - A/R"

Scenario: _9808 check All registers movements
	Given I open hyperlink "e1cib/app/Report.AllRegistersMovement"
	And I remove checkbox named "SettingsComposerUserSettingsItem0Use"
	And I click "Run report" button
	And "Result" spreadsheet document contains "ErrorTest9808" template lines by template
	
Scenario: _9809 check Items info
	Given I open hyperlink "e1cib/app/Report.ItemsInfo"
	And I click "Run report" button
	And "Result" spreadsheet document contains "ErrorTest9809" template lines by template	
	
		


