#language: en
@tree
@Positive


Feature: check the addition of commands to documents and document lists



Background:
	Given I launch TestClient opening script or connect the existing one

	
Scenario: _0205001 preparation
	* Add test plugin
		* Open form to add plugin
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			And I click the button named "FormCreate"
		* Filling plugin data and adding it to the database
			And I select external file "#workingDir#\DataProcessor\CheckExternalCommands.epf"
			And I click the button named "FormAddExtDataProc"
			And I input "" text in "Path to plugin for test" field
			And I input "PrintFormSalesOrder" text in "Name" field
			And I click Open button of the field named "Description_en"
			And I input "Test command" text in "ENG" field
			And I input "Test command tr" text in "TR" field
			And I click "Ok" button
			And I click "Save and close" button
			And Delay 5
		* Check the addition of plugin
			Then I check for the "ExternalDataProc" catalog element with the "Description_en" "Test command"
	* Add test Purchase invoice
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
			* Filling the document header
				And I click Select button of "Partner" field
				And I go to line in "List" table
					| 'Description'  |
					| 'Ferron BP' |
				And I select current line in "List" table
				And I click Select button of "Legal name" field
				And I go to line in "List" table
					| 'Description'  |
					| 'Company Ferron BP' |
				And I select current line in "List" table
				And I click Select button of "Company" field
				And I go to line in "List" table
					| 'Description'  |
					| 'Main Company' |
				And I select current line in "List" table
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'  |
					| 'Vendor Ferron, TRY' |
				And I select current line in "List" table
				And I click Select button of "Store" field
				And I go to line in "List" table
					| 'Description' |
					| 'Store 02'    |
				And I select current line in "List" table
			* Filling in the tabular part
				And I click "Add" button
				And I click choice button of "Item" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Description' |
					| 'Boots'       |
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item'  | 'Item key' |
					| 'Boots' | '37/18SD'  |
				And I select current line in "List" table
				And I activate "Q" field in "ItemList" table
				And I input "15,000" text in "Q" field of "ItemList" table
				And I input "210,000" text in "Price" field of "ItemList" table
				And I finish line editing in "ItemList" table
				And I click "Add" button
				And I click choice button of "Item" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Description' |
					| 'Dress'       |
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item'  | 'Item key' |
					| 'Dress' | 'L/Green'  |
				And I select current line in "List" table
				And I activate "Q" field in "ItemList" table
				And I input "8,000" text in "Q" field of "ItemList" table
				And I input "350,000" text in "Price" field of "ItemList" table
				And I finish line editing in "ItemList" table
				And I click "Add" button
				And I click choice button of "Item" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Description' |
					| 'Service'       |
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item'  | 'Item key' |
					| 'Service' | 'Rent'  |
				And I select current line in "List" table
				And I activate "Q" field in "ItemList" table
				And I input "1,000" text in "Q" field of "ItemList" table
				And I input "100,000" text in "Price" field of "ItemList" table
				And I finish line editing in "ItemList" table
			* Change the document number
				And I move to "Other" tab
				And I input "3 900" text in "Number" field
				Then "1C:Enterprise" window is opened
				And I click "Yes" button
				And I input "3 900" text in "Number" field
			* Post and check saving
				And I click "Post and close" button
				And "List" table contains lines
					| 'Number' |
					| '3 900'       |

Scenario: _0205002 add test command to the list of documents Sales return
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Sales return
		* Create metadata for Sales return and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I move one level down in "List" table
			And I click the button named "FormCreate"
			And I input "SalesReturn" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'SalesReturn'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins' |
		| 'SalesReturn'             | 'Test command'       |
	* Check the command from the document list Sales Return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'SalesReturn' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'SalesReturn' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205003 add test command to the list of documents Sales invoice
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Sales invoice
		* Create metadata for Sales invoice and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "SalesInvoice" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'SalesInvoice'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins' |
		| 'SalesInvoice'             | 'Test command'       |
	* Check the command from the document list Sales Invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'SalesInvoice' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'SalesInvoice' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205004 add test command to the list of documents Purchase order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Purchase order
		* Create metadata for Purchase order and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "PurchaseOrder" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'PurchaseOrder'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins' |
		| 'PurchaseOrder'             | 'Test command'       |
	* Check the command from the document list Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PurchaseOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PurchaseOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205005 add test command to the list of documents Sales order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Sales order
		* Create metadata for sales order and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "SalesOrder" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'SalesOrder'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins' |
		| 'SalesOrder'             | 'Test command'       |
	* Check the command from the document list SalesOrder
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'SalesOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'SalesOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205006 add test command to the list of documents Purchase invoice
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Purchase invoice
		* Create metadata for Purchase invoice and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "PurchaseInvoice" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'PurchaseInvoice'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins' |
		| 'PurchaseInvoice'             | 'Test command'       |
	* Check the command from the document list PurchaseInvoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PurchaseInvoice' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PurchaseInvoice' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows


Scenario: _0205007 add test command to the list of documents Cash transfer order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Cash transfer order
		* Create metadata for Cash transfer order and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "CashTransferOrder" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'CashTransferOrder'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins' |
		| 'CashTransferOrder'             | 'Test command'       |
	* Check the command from the document list CashTransferOrder
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'CashTransferOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'CashTransferOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows


Scenario: _0205008 add test command to the list of documents Shipment confirmation
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Shipment confirmation
		* Create metadata for Shipment confirmation and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "ShipmentConfirmation" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'ShipmentConfirmation'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'           | 'Plugins' |
		| 'ShipmentConfirmation'             | 'Test command'       |
	* Check the command from the document list CashTransferOrder
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'ShipmentConfirmation' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'ShipmentConfirmation' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows


Scenario: _0205009 add test command to the list of documents Goods receipt
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Goods receipt
		* Create metadata for Goods receipt and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "GoodsReceipt" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'GoodsReceipt'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'           | 'Plugins' |
		| 'GoodsReceipt'             | 'Test command'       |
	* Check the command from the document list GoodsReceipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'GoodsReceipt' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'GoodsReceipt' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205010 add test command to the list of documents Sales return order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Sales return order
		* Create metadata for Sales return order and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "SalesReturnOrder" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'SalesReturnOrder'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'SalesReturnOrder'             | 'Test command'       |
	* Check the command from the document list SalesReturnOrder
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'SalesReturnOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'SalesReturnOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows


Scenario: _0205011 add test command to the list of documents Purchase return order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Purchase return order
		* Create metadata for Purchase return order and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "PurchaseReturnOrder" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'PurchaseReturnOrder'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'PurchaseReturnOrder'             | 'Test command'       |
	* Check the command from the document list PurchaseReturnOrder
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PurchaseReturnOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PurchaseReturnOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205012 add test command to the list of documents ReconciliationStatement
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Reconciliation statement
		* Create metadata for ReconciliationStatement and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "ReconciliationStatement" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'ReconciliationStatement'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'ReconciliationStatement'                | 'Test command'       |
	* Check the command from the document list ReconciliationStatement
		Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'ReconciliationStatement' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'ReconciliationStatement' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows


Scenario: _0205013 add test command to the list of documents BankPayment
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Bank payment
		* Create metadata for BankPayment and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "BankPayment" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'BankPayment'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'BankPayment'                | 'Test command'       |
	* Check the command from the document list Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'BankPayment' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'BankPayment' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205014 add test command to the list of documents BankReceipt
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Bank receipt
		* Create metadata for BankReceipt and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "BankReceipt" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'BankReceipt'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'BankReceipt'                | 'Test command'       |
	* Check the command from the document list BankReceipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'BankReceipt' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'BankReceipt' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows


Scenario: _0205016 add test command to the list of documents Bundling
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Bundling
		* Create metadata for Bundling and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "Bundling" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'Bundling'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'Bundling'                | 'Test command'       |
	* Check the command from the document list Bundling
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'Bundling' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'Bundling' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205017 add test command to the list of documents CashExpense
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for CashExpense
		* Create metadata for CashExpense and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "CashExpense" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'CashExpense'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'CashExpense'                | 'Test command'       |
	* Check the command from the document list CashExpense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'CashExpense' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'CashExpense' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows


Scenario: _0205018 add test command to the list of documents CashPayment
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Cash payment
		* Create metadata for CashPayment and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "CashPayment" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'CashPayment'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'CashPayment'                | 'Test command'       |
	* Check the command from the document list CashPayment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'CashPayment' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'CashPayment' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205019 add test command to the list of documents Cash Receipt
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Cash Receipt
		* Create metadata for CashReceipt and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "CashReceipt" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'CashReceipt'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'CashReceipt'                | 'Test command'       |
	* Check the command from the document list CashReceipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'CashReceipt' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'CashReceipt' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205020 add test command to the list of documents Cash Revenue
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for CashRevenue
		* Create metadata for CashRevenue and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "CashRevenue" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'CashRevenue'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'CashRevenue'                | 'Test command'       |
	* Check the command from the document list CashRevenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'CashRevenue' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'CashRevenue' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows


Scenario: _0205022 add test command to the list of documents Cheque bond transaction
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Cheque bond transaction
		* Create metadata for Cheque bond transaction and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "ChequeBondTransaction" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'ChequeBondTransaction'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'ChequeBondTransaction'                | 'Test command'       |
	* Check the command from the document list ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'ChequeBondTransaction' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'ChequeBondTransaction' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows



Scenario: _0205023 add test command to the list of documents Credit Debit Note
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Credit Debit Note
		* Create metadata for CreditDebitNote and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "CreditDebitNote" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'CreditDebitNote'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'CreditDebitNote'                | 'Test command'       |
	* Check the command from the document list CreditDebitNote
		Given I open hyperlink "e1cib/list/Document.CreditDebitNote"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'CreditDebitNote' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.CreditDebitNote"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'CreditDebitNote' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows


Scenario: _0205024 add test command to the list of documents Incoming Payment Order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for IncomingPaymentOrder
		* Create metadata for IncomingPaymentOrder and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "IncomingPaymentOrder" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'IncomingPaymentOrder'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'IncomingPaymentOrder'                | 'Test command'       |
	* Check the command from the document list IncomingPaymentOrder
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'IncomingPaymentOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'IncomingPaymentOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205025 add test command to the list of documents Internal Supply Request
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for InternalSupplyRequest
		* Create metadata for InternalSupplyRequest and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "InternalSupplyRequest" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'InternalSupplyRequest'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'InternalSupplyRequest'                | 'Test command'       |
	* Check the command from the document list InternalSupplyRequest
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'InternalSupplyRequest' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'InternalSupplyRequest' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205026 add test command to the list of documents Inventory Transfer
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Inventory Transfer
		* Create metadata for Inventory Transfer and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "InventoryTransfer" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'InventoryTransfer'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'InventoryTransfer'                | 'Test command'       |
	* Check the command from the document list InventoryTransfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'InventoryTransfer' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'InventoryTransfer' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205027 add test command to the list of documents Inventory Transfer Order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for InventoryTransferOrder
		* Create metadata for InventoryTransferOrder and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "InventoryTransferOrder" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'InventoryTransferOrder'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'InventoryTransferOrder'                | 'Test command'       |
	* Check the command from the document list InventoryTransferOrder
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'InventoryTransferOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'InventoryTransferOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205028 add test command to the list of documents Invoice Match
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Invoice Match
		* Create metadata for InvoiceMatch and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "InvoiceMatch" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'InvoiceMatch'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'InvoiceMatch'                | 'Test command'       |
	* Check the command from the document list InvoiceMatch
		Given I open hyperlink "e1cib/list/Document.InvoiceMatch"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'InvoiceMatch' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.InvoiceMatch"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'InvoiceMatch' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205029 add test command to the list of documents Labeling
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Labeling
		* Create metadata for Labeling and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "Labeling" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'Labeling'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'Labeling'                | 'Test command'       |
	* Check the command from the document list Labeling
		Given I open hyperlink "e1cib/list/Document.Labeling"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'Labeling' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.Labeling"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'Labeling' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205030 add test command to the list of documents Opening Entry
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for OpeningEntry
		* Create metadata for OpeningEntry and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "OpeningEntry" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'OpeningEntry'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'OpeningEntry'                | 'Test command'       |
	* Check the command from the document list OpeningEntry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'OpeningEntry' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'OpeningEntry' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows


Scenario: _0205031 add test command to the list of documents Outgoing Payment Order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for OutgoingPaymentOrder
		* Create metadata for OutgoingPaymentOrder and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "OutgoingPaymentOrder" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'OutgoingPaymentOrder'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'OutgoingPaymentOrder'                | 'Test command'       |
	* Check the command from the document list OutgoingPaymentOrder
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'OutgoingPaymentOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'OutgoingPaymentOrder' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205032 add test command to the list of documents Physical Count By Location
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Physical Count By Location
		* Create metadata for Physical Count By Location and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "PhysicalCountByLocation" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'PhysicalCountByLocation'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'PhysicalCountByLocation'                | 'Test command'       |
	* Check the command from the document list PhysicalCountByLocation
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PhysicalCountByLocation' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PhysicalCountByLocation' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205033 add test command to the list of documents Price List
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Price List
		* Create metadata for PriceList and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "PriceList" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'PriceList'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'PriceList'                | 'Test command'       |
	* Check the command from the document list PriceList
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PriceList' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PriceList' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows



Scenario: _0205035 add test command to the list of documents PurchaseReturn
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for PurchaseReturn
		* Create metadata for PurchaseReturn and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "PurchaseReturn" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'PurchaseReturn'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'PurchaseReturn'                | 'Test command'       |
	* Check the command from the document list PurchaseReturn
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PurchaseReturn' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PurchaseReturn' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows



Scenario: _0205037 add test command to the list of documents Unbundling
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Unbundling
		* Create metadata for Unbundling and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "Unbundling" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'Unbundling'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'Unbundling'                | 'Test command'       |
	* Check the command from the document list Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'Unbundling' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'Unbundling' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205038 add test command to the list of documents Stock Adjustment As Write Off
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for StockAdjustmentAsWriteOff
		* Create metadata for StockAdjustmentAsWriteOff and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "StockAdjustmentAsWriteOff" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'StockAdjustmentAsWriteOff'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'StockAdjustmentAsWriteOff'                | 'Test command'       |
	* Check the command from the document list StockAdjustmentAsWriteOff
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'StockAdjustmentAsWriteOff' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'StockAdjustmentAsWriteOff' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205039 add test command to the list of documents Stock Adjustment As Surplus
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Stock Adjustment As Surplus
		* Create metadata for Stock Adjustment As Surplus and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "StockAdjustmentAsSurplus" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'StockAdjustmentAsSurplus'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'StockAdjustmentAsSurplus'                | 'Test command'       |
	* Check the command from the document list StockAdjustmentAsSurplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'StockAdjustmentAsSurplus' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is not displayed in the document
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'StockAdjustmentAsSurplus' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows

Scenario: _0205040 add test command to the list of documents Physical Inventory
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Physical Inventory
		* Create metadata for Physical Inventory and select it for the command
			And I click Select button of "Configuration metadata" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I click the button named "FormCreate"
			And I input "PhysicalInventory" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description' |
				| 'Documents'   |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'PhysicalInventory'  |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Test command' |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins' |
		| 'PhysicalInventory'                | 'Test command'       |
	* Check the command from the document list PhysicalInventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			|'And I click "Test command" button'|
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PhysicalInventory' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click "Create" button
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows
	* Connect the command to the document selection form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'       |
				| 'PhysicalInventory' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Test command' |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		And I close all client application windows


Scenario: _010017 command opening contact information in the partner list
	* Open catalog Partners and select partner
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso' |
		And I click "Contact info" button
	* Check the display of contact information
		And "IDInfo" table contains lines
			| 'Type'                       |
			| 'Location address (Partner)' |
			| 'GPS Ukraine'                |
			| 'Partner phone'              |
	And I close all client application windows


Scenario: _010018 check edit contact information from the Edit contact info form
	* Open catalog Partners and select partner
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso' |
		And I click "Contact info" button
	* Edit contact info
		And I input "Odessa, Bunina, 2, №33" text in "Value" field of "IDInfo" table
		And I finish line editing in "IDInfo" table
		And I click "Save and close" button
	* Check saving of changed contact information
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso' |
		And I select current line in "List" table
		And I move to "Contact information" tab
		Then the form attribute named "_Adr_1" became equal to "Odessa, Bunina, 2, №33"
	And I close all client application windows



Scenario: _010019 check the operation of the command to open an item list from Item type
	* Open catalog Item type
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description' |
			| 'Shoes' |
		And I select current line in "List" table
		And In this window I click command interface button "Items"
	* Filter check by items
		And "List" table contains lines
		| 'Description'| 'Item type' |
		| 'Boots'      | 'Shoes'     |
		| 'High shoes' | 'Shoes'     |
		And "List" table does not contain lines
		| 'Description'   | 'Item type' |
		| 'Dress'         | 'Shoes'     |
	And I close all client application windows



Scenario: _010020 check the operation of Quantity Compare plugin (comparison of the plan / fact in Goods reciept)
	* Create Goods reciept based on PI 3900
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '3 900' |
		And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
	* Check filling in Goods Receipt
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Currency' | 'Item key' | 'Store'    | 'Unit' | 'Receipt basis'           |
			| 'Dress' | '8,000'    | 'TRY'      | 'L/Green'  | 'Store 02' | 'pcs'  | 'Purchase invoice 3 900*' |
			| 'Boots' | '15,000'   | 'TRY'      | '37/18SD'  | 'Store 02' | 'pcs'  | 'Purchase invoice 3 900*' |
	* Open Quantity Compare
		And I click "Compare quantity" button
	* Check of adding goods by barcode search
		And in the table "PhysItemList" I click the button named "PhysItemListSearchByBarcode"
		And I input "978020137962" text in "InputFld" field
		And I click "OK" button
		And in the table "PhysItemList" I click the button named "PhysItemListSearchByBarcode"
		And I input "978020137962" text in "InputFld" field
		And I click "OK" button
		And in the table "PhysItemList" I click the button named "PhysItemListSearchByBarcode"
		And I input "2202283739" text in "InputFld" field
		And I click "OK" button
		And in the table "PhysItemList" I click the button named "PhysItemListSearchByBarcode"
		And I input "2202283739" text in "InputFld" field
		And I click "OK" button
		And in the table "PhysItemList" I click the button named "PhysItemListSearchByBarcode"
		And I input "2202283739" text in "InputFld" field
		And I click "OK" button
		And "PhysItemList" table contains lines
			| 'Item'  | 'Item key' | 'Unit' | 'Q'     |
			| 'Boots' | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Dress' | 'L/Green'  | 'pcs'  | '3,000' |
	* Add items manually via the Add button
		And in the table "PhysItemList" I click the button named "PhysItemListAdd"
		And I click choice button of the attribute named "PhysItemListItem" in "PhysItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "PhysItemListItemKey" in "PhysItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table
		# temporarily
		And I click choice button of the attribute named "PhysItemListUnit" in "PhysItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'pcs'         |
		And I select current line in "List" table
		# temporarily
		And I activate field named "PhysItemListCount" in "PhysItemList" table
		And I input "1,000" text in the field named "PhysItemListCount" of "PhysItemList" table
		And "PhysItemList" table contains lines
			| 'Item'  | 'Item key' | 'Unit' | 'Q'     |
			| 'Boots' | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Dress' | 'L/Green'  | 'pcs'  | '3,000' |
			| 'Boots' | '38/18SD'  | 'pcs'  | '1,000' |
	* Add items via the Pick up button
		And in the table "PhysItemList" I click the button named "PhysItemListOpenPickupItems"
		And I go to line in "ItemList" table
			| Title |
			| Dress |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| Title   |
			| L/Green |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemTableValue" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green' |
		And I select current line in "ItemTableValue" table
		And I finish line editing in "ItemTableValue" table
		And I click the button named "FormCommandSaveAndClose"
		And "PhysItemList" table contains lines
			| 'Item'  | 'Item key' | 'Unit' | 'Q'     |
			| 'Boots' | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Dress' | 'L/Green'  | 'pcs'  | '4,000' |
			| 'Boots' | '38/18SD'  | 'pcs'  | '1,000' |
	* Difference reconciliation
		And in the table "PhysItemList" I click the button named "PhysItemListSwitchItemLists"
		Then the number of "CompareItemList" table lines is "<=" 3
		And "CompareItemList" table became equal
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Dress' | '8,000'    | '-4,000'     | 'L/Green'  | 'pcs'  | '4,000' |
			| 'Boots' | '15,000'   | '-13,000'    | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
	* Check quantity changes manually on the scan tab
		And in the table "CompareItemList" I click the button named "CompareItemListSwitchItemLists"
		And I activate field named "PhysItemListCount" in "PhysItemList" table
		And I go to line in "PhysItemList" table
			| 'Item'  | 'Item key' | 'Q'     | 'Unit' |
			| 'Dress' | 'L/Green'  | '4,000' | 'pcs'  |
		And I select current line in "PhysItemList" table
		And I input "5,000" text in the field named "PhysItemListCount" of "PhysItemList" table
		And I finish line editing in "PhysItemList" table
		And "PhysItemList" table contains lines
			| 'Item'  | 'Item key' | 'Unit' | 'Q'     |
			| 'Boots' | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Dress' | 'L/Green'  | 'pcs'  | '5,000' |
	* Check quantity changes manually on the comparison tab
		And in the table "PhysItemList" I click the button named "PhysItemListSwitchItemLists"
		And "CompareItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Dress' | '8,000'    | '-3,000'     | 'L/Green'  | 'pcs'  | '5,000' |
			| 'Boots' | '15,000'   | '-13,000'    | '37/18SD'  | 'pcs'  | '2,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
		And I go to line in "CompareItemList" table
			| 'Count' | 'Difference' | 'Item'  | 'Item key' | 'Quantity' | 'Unit' |
			| '2,000' | '-13,000'    | 'Boots' | '37/18SD'  | '15,000'   | 'pcs'  |
		And I select current line in "CompareItemList" table
		And I input "3,000" text in "Count" field of "CompareItemList" table
		And I finish line editing in "CompareItemList" table
		And "CompareItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Dress' | '8,000'    | '-3,000'     | 'L/Green'  | 'pcs'  | '5,000' |
			| 'Boots' | '15,000'   | '-12,000'    | '37/18SD'  | 'pcs'  | '3,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
	* Delete lines in scan tab
		And in the table "CompareItemList" I click the button named "CompareItemListSwitchItemLists"
		And I go to line in "PhysItemList" table
			| 'Item'  | 'Item key' | 'Q'     | 'Unit' |
			| 'Dress' | 'L/Green'  | '5,000' | 'pcs'  |
		And in the table "PhysItemList" I click the button named "PhysItemListDelete"
		Then the number of "PhysItemList" table lines is "<=" 2
	* Add items by scanning on the tab "CompareItemList"
		And in the table "PhysItemList" I click the button named "PhysItemListSwitchItemLists"
		And in the table "CompareItemList" I click the button named "CompareItemListSearchByBarcode"
		And I input "978020137962" text in "InputFld" field
		And I click "OK" button
		And "CompareItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Boots' | '15,000'   | '-11,000'    | '37/18SD'  | 'pcs'  | '4,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
		Then the number of "CompareItemList" table lines is "<=" 2
	* Add items to the tab "CompareItemList" through the Add button
		And in the table "CompareItemList" I click the button named "CompareItemListAdd"
		And I click choice button of the attribute named "CompareItemListItem" in "CompareItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate field named "CompareItemListItemKey" in "CompareItemList" table
		And I click choice button of the attribute named "CompareItemListItemKey" in "CompareItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '38/Black' |
		And I select current line in "List" table
		And I activate field named "CompareItemListUnit" in "CompareItemList" table
		And I click choice button of the attribute named "CompareItemListUnit" in "CompareItemList" table
		And I select current line in "List" table
		And I activate "Count" field in "CompareItemList" table
		And I input "1,000" text in "Count" field of "CompareItemList" table
		And I finish line editing in "CompareItemList" table
		And "CompareItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Boots' | '15,000'   | '-11,000'    | '37/18SD'  | 'pcs'  | '4,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
			| 'Shirt' | ''         | '1,000'      | '38/Black' | 'pcs'  | '1,000' |
		Then the number of "CompareItemList" table lines is "<=" 3
	* Add items to the tab "CompareItemList" through the Pick up button
		And in the table "CompareItemList" I click the button named "CompareItemListOpenPickupItems"
		And I go to line in "ItemList" table
			| 'Title' |
			| 'Shirt' |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| 'Title'  | 'Unit' |
			| '36/Red' | 'pcs'  |
		And I select current line in "ItemKeyList" table
		And I click "Transfer to document" button
		And "CompareItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Boots' | '15,000'   | '-11,000'    | '37/18SD'  | 'pcs'  | '4,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
			| 'Shirt' | ''         | '1,000'      | '38/Black' | 'pcs'  | '1,000' |
			| 'Shirt' | ''         | '1,000'      | '36/Red'   | 'pcs'  | '1,000' |
		Then the number of "CompareItemList" table lines is "<=" 4
	* Collapse of the tabular part with data on documents-bases
		And "ExpItemList" table contains lines
			| 'Item'  | 'Item key' | 'Base on'                 | 'Unit' | 'Q'      |
			| 'Dress' | 'L/Green'  | 'Purchase invoice 3 900*' | 'pcs'  | '8,000'  |
			| 'Boots' | '37/18SD'  | 'Purchase invoice 3 900*' | 'pcs'  | '15,000' |
		* Check the ExpItemList table collapse 
			And I click "Show hide exp. item list" button
			When I Check the steps for Exception
			|'Then I select all lines of "ExpItemList" table'|
		* Check the ExpItemList table uncolapse
			And I click "Show hide exp. item list" button
			And "ExpItemList" table contains lines
			| 'Item'  | 'Item key' | 'Base on'                 | 'Unit' | 'Q'      |
			| 'Dress' | 'L/Green'  | 'Purchase invoice 3 900*' | 'pcs'  | '8,000'  |
			| 'Boots' | '37/18SD'  | 'Purchase invoice 3 900*' | 'pcs'  | '15,000' |
	* Check the transfer of filled items to Goods reciept
		And in the table "PhysItemList" I click the button named "PhysItemListSwitchItemLists"
		And "CompareItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Difference' | 'Item key' | 'Unit' | 'Count' |
			| 'Boots' | '15,000'   | '-12,000'    | '37/18SD'  | 'pcs'  | '3,000' |
			| 'Boots' | ''         | '1,000'      | '38/18SD'  | 'pcs'  | '1,000' |
		And I click "Transfer to document" button
		And "ItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Item key' | 'Store'    | 'Unit' | 'Receipt basis'                    |
			| 'Boots' | '3,000'    | '37/18SD'  | 'Store 02' | 'pcs'  | 'Purchase invoice 3 900*'          |
			| 'Boots' | '1,000'    | '38/18SD'  | 'Store 02' | 'pcs'  | ''                                 |
		And I close all client application windows
