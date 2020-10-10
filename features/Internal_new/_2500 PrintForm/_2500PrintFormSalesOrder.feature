#language: en
@tree
@Positive
@PrintForm

Feature: check print functionality (Sales order)



Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _092001 preparation (PrintFormSalesOrder)
	* Constants
		When set True value to the constant
	* Load info
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
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
		When add sales tax settings 

Scenario: _25001 adding print plugin for sales order
	* Open form to add plugin
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		And I click the button named "FormCreate"
	* Filling plugin data and adding it to the database
		And I select external file "#workingDir#\DataProcessor\PrintFormSalesOrder.epf"
		And I click the button named "FormAddExtDataProc"
		And I input "" text in "Path to plugin for test" field
		And I input "PrintFormSalesOrder" text in "Name" field
		And I click Open button of the field named "Description_en"
		And I input "Sales order" text in the field named "Description_en"
		And I input "Sales order tr" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
	* Check the addition of plugin
		Then I check for the "ExternalDataProc" catalog element with the "Description_en" "Sales order"

Scenario: _25002 create a print command for Sales order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
	* Filling test command data for Sales order
		* Create metadata for sales order and select it for the command
			If "List" table does not contain lines Then
				| 'Description' |
				| 'SalesOrder'  |
				And I click the button named "FormCreate"
				And I click Select button of "Configuration metadata" field
				And I go to line in "List" table
					| 'Description' |
					| 'Documents'   |
				And I move one level down in "List" table
				And I click the button named "FormCreate"
				And I input "SalesOrder" text in "Description" field
				And I click "Save and close" button
				And I go to line in "List" table
					| 'Description' |
					| 'SalesOrder'  |
				And I click the button named "FormChoose"
				And I click Select button of "Plugins" field
				And I go to line in "List" table
					| 'Description' |
					| 'Sales order' |
				And I select current line in "List" table 
				And I click "Save and close" button		
			And I go to line in "List" table
				| 'Configuration metadata' |
				| 'SalesOrder'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Sales Order' |
			And I select current line in "List" table
		* Set UI group for command
			And I click Select button of "UI group" field
			* Create UI group Print
				And I click the button named "FormCreate"
				And I input "Print" text in the field named "Description_en"
				And I click Open button of "ENG" field
				And I input "Print" text in the field named "Description_tr"
				And I input "Печать" text in "RU" field
				And I click "Ok" button
				And I click "Save and close" button
			And I click the button named "FormChoose"
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata' | 'Plugins' | 'UI group' |
		| 'SalesOrder'             | 'Sales Order'        | 'Print'           |

Scenario: _25003 check Sales order printing
	And I delete "$$NumberSalesOrder5003$$" variable
	And I delete "$$DateSalesOrder5003$$" variable
	And I delete "$$SalesOrder25003$$" variable
	* Create Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                   |
			| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '36/Red'  |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Post document
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberSalesOrder5003$$"
		And I save the value of "Number" field as "$$DateSalesOrder5003$$"
		And I save the window as "$$SalesOrder25003$$"
		And I click the button named "FormPostAndClose"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesOrder5003$$'  |
		And I select current line in "List" table
	* Printing out of a document
		And I click "Sales Order" button
	* Check printing form
		And I wait "Table" window opening in 20 seconds
		Given "" spreadsheet document is equal to "SalesOrderPrintForm" by template
		And Delay 30
	And I close all client application windows


Scenario: _999999 close TestClient session
	And I close TestClient session