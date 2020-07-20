#language: en
@tree
@Positive

Feature: check print functionality (Sales order)



Background:
	Given I launch TestClient opening script or connect the existing one



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
		And I input "Sales order" text in "ENG" field
		And I input "Sales order tr" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
	* Check the addition of plugin
		Then I check for the "ExternalDataProc" catalog element with the "Description_en" "Sales order"

Scenario: _25002 create a print command for Sales order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Sales order
		* Create metadata for sales order and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I go to line in "List" table
				| 'Description' |
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
				And I input "Print" text in "ENG" field
				And I click Open button of "ENG" field
				And I input "Print" text in "TR" field
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
	* Change document number and date
		And I move to "Other" tab
		And I input "8 000" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "8 000" text in "Number" field
		And I input "01.12.2019  0:00:01" text in "Date" field
		And I move to "Item list" tab
	* Post document
		And I click "Post and close" button
		And I go to line in "List" table
		| 'Number' |
		| '8 000'  |
		And I select current line in "List" table
	* Printing out of a document
		And I click "Sales Order" button
	* Check printing form
		And I wait "Table" window opening in 20 seconds
		Given "" spreadsheet document is equal to "SalesOrderPrintForm" by template
		And Delay 30
	And I close all client application windows











