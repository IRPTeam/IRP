#language: en
@tree
@Positive
@Forms

Feature: check the addition of commands to documents and document lists


Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _0205001 preparation (commands)
	When set True value to the constant
	When set True value to the constant Use accounting
	When set True value to the constant Use salary
	When set True value to the constant Use commission trading
	When set True value to the constant Use fixed assets
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
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
		When Create catalog Partners objects (trade agent and consignor)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)
	* Add test plugin
		* Open form to add plugin
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			And I click the button named "FormCreate"
		* Filling plugin data and adding it to the database
			And I select external file "$Path$/features/External/step_definitions/CheckExternalCommands.epf"
			And I click the button named "FormAddExtDataProc"
			And I input "" text in "Path to plugin for test" field
			And I input "PrintFormSalesOrder" text in "Name" field
			And I click Open button of the field named "Description_en"
			And I input "Test command" text in the field named "Description_en"
			And I input "Test command tr" text in the field named "Description_tr"
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
					| 'Description'      |
					| 'Ferron BP'        |
				And I select current line in "List" table
				And I click Select button of "Legal name" field
				And I go to line in "List" table
					| 'Description'            |
					| 'Company Ferron BP'      |
				And I select current line in "List" table
				And I click Select button of "Company" field
				And I go to line in "List" table
					| 'Description'       |
					| 'Main Company'      |
				And I select current line in "List" table
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'             |
					| 'Vendor Ferron, TRY'      |
				And I select current line in "List" table
				And I click Select button of "Store" field
				And I go to line in "List" table
					| 'Description'      |
					| 'Store 02'         |
				And I select current line in "List" table
			* Filling in the tabular part
				And I click "Add" button
				And I click choice button of "Item" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Description'      |
					| 'Boots'            |
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item'      | 'Item key'      |
					| 'Boots'     | '37/18SD'       |
				And I select current line in "List" table
				And I activate "Quantity" field in "ItemList" table
				And I input "15,000" text in "Quantity" field of "ItemList" table
				And I input "210,000" text in "Price" field of "ItemList" table
				And I finish line editing in "ItemList" table
				And I click "Add" button
				And I click choice button of "Item" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Description'      |
					| 'Dress'            |
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item'      | 'Item key'      |
					| 'Dress'     | 'L/Green'       |
				And I select current line in "List" table
				And I activate "Quantity" field in "ItemList" table
				And I input "8,000" text in "Quantity" field of "ItemList" table
				And I input "350,000" text in "Price" field of "ItemList" table
				And I finish line editing in "ItemList" table
				And I click "Add" button
				And I click choice button of "Item" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Description'      |
					| 'Service'          |
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item'        | 'Item key'      |
					| 'Service'     | 'Rent'          |
				And I select current line in "List" table
				And I activate "Quantity" field in "ItemList" table
				And I input "1,000" text in "Quantity" field of "ItemList" table
				And I input "100,000" text in "Price" field of "ItemList" table
				And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0205001$$" variable
			And I delete "$$PurchaseInvoice0205001$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0205001$$"
			And I save the window as "$$PurchaseInvoice0205001$$"
			* Post and check saving
				And I click the button named "FormPostAndClose"
				And "List" table contains lines
					| 'Number'                                |
					| '$$NumberPurchaseInvoice0205001$$'      |
	// * Add plugin QuantityCompare
	// 	* Open form to add plugin
	// 		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
	// 		And I click the button named "FormCreate"
	// 	* Filling plugin data and adding it to the database
	// 		And I select external file "$Path$/DataProcessor/QuantityCompare.epf"
	// 		And I click the button named "FormAddExtDataProc"
	// 		And I input "" text in "Path to plugin for test" field
	// 		And I input "CompareQuantity" text in "Name" field
	// 		And I click Open button of the field named "Description_en"
	// 		And I input "Compare quantity" text in the field named "Description_en"
	// 		And I input "Compare quantity tr" text in the field named "Description_tr"
	// 		And I click "Ok" button
	// 		And I click "Save and close" button
	// 		And Delay 5
	// 	* Check the addition of plugin
	// 		Then I check for the "ExternalDataProc" catalog element with the "Description_en" "Compare quantity"
		* Create test configuration metadata
			Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
			And I click "List" button			
			And I click the button named "FormCreate"
			And I input "GoodReceip1" text in "Description" field
			And I click Select button of "Parent" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Documents'       |
			And I select current line in "List" table
			And I input "GoodReceip1" text in "Object name" field
			And I input "Document.GoodReceipt1" text in "Object full name" field	
			And I click "Save and close" button
	When auto filling Configuration metadata catalog
	* Add VA extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description"     |
				| "VAExtension"     |
			When add VAExtension


Scenario: _02050011 check preparation
	When check preparation

Scenario: _0205002 add test command to the list of documents Sales return
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Sales return
		* Create metadata for Sales return and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button			
			And I go to line in "List" table
				| 'Description'      |
				| 'Sales return'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Sales return'            | 'Test command'   |
	* Check the command from the document list Sales Return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'      |
				| 'Sales return'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'      |
				| 'Sales return'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.SalesReturn.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205003 add test command to the list of documents Sales invoice
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Sales invoice
		* Create metadata for Sales invoice and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'       |
				| 'Sales invoice'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Sales invoice'           | 'Test command'   |
	* Check the command from the document list Sales Invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
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
				| 'Sales invoice'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Sales invoice'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.SalesInvoice.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205004 add test command to the list of documents Purchase order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Purchase order
		* Create metadata for Purchase order and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'        |
				| 'Purchase order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Purchase order'          | 'Test command'   |
	* Check the command from the document list Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'        |
				| 'Purchase order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'        |
				| 'Purchase order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.PurchaseOrder.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205005 add test command to the list of documents Sales order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Sales order
		* Create metadata for sales order and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Sales order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Sales order'             | 'Test command'   |
	* Check the command from the document list SalesOrder
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Sales order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'     |
				| 'Sales order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.SalesOrder.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205006 add test command to the list of documents Purchase invoice
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Purchase invoice
		* Create metadata for Purchase invoice and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'          |
				| 'Purchase invoice'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Purchase invoice'        | 'Test command'   |
	* Check the command from the document list PurchaseInvoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'          |
				| 'Purchase invoice'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'          |
				| 'Purchase invoice'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.PurchaseInvoice.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _0205007 add test command to the list of documents Cash transfer order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Cash transfer order
		* Create metadata for Cash transfer order and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'             |
				| 'Cash transfer order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Cash transfer order'     | 'Test command'   |
	* Check the command from the document list CashTransferOrder
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'             |
				| 'Cash transfer order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'             |
				| 'Cash transfer order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.CashTransferOrder.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _0205008 add test command to the list of documents Shipment confirmation
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Shipment confirmation
		* Create metadata for Shipment confirmation and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'               |
				| 'Shipment confirmation'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Shipment confirmation'   | 'Test command'   |
	* Check the command from the document list CashTransferOrder
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'               |
				| 'Shipment confirmation'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'               |
				| 'Shipment confirmation'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.ShipmentConfirmation.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _0205009 add test command to the list of documents Goods receipt
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Goods receipt
		* Create metadata for Goods receipt and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'       |
				| 'Goods receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Goods receipt'           | 'Test command'   |
	* Check the command from the document list GoodsReceipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
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
				| 'Goods receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Goods receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.GoodsReceipt.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205010 add test command to the list of documents Sales return order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Sales return order
		* Create metadata for Sales return order and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'            |
				| 'Sales return order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Sales return order'      | 'Test command'   |
	* Check the command from the document list SalesReturnOrder
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'            |
				| 'Sales return order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'            |
				| 'Sales return order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.SalesReturnOrder.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _0205011 add test command to the list of documents Purchase return order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Purchase return order
		* Create metadata for Purchase return order and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'               |
				| 'Purchase return order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Purchase return order'   | 'Test command'   |
	* Check the command from the document list PurchaseReturnOrder
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'               |
				| 'Purchase return order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'               |
				| 'Purchase return order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.PurchaseReturnOrder.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205012 add test command to the list of documents ReconciliationStatement
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Reconciliation statement
		* Create metadata for ReconciliationStatement and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                  |
				| 'Reconciliation statement'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'    | 'Plugins'        |
		| 'Reconciliation statement'  | 'Test command'   |
	* Check the command from the document list ReconciliationStatement
		Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                  |
				| 'Reconciliation statement'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'                  |
				| 'Reconciliation statement'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.ReconciliationStatement.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _0205013 add test command to the list of documents BankPayment
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Bank payment
		* Create metadata for BankPayment and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'      |
				| 'Bank payment'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Bank payment'            | 'Test command'   |
	* Check the command from the document list Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'      |
				| 'Bank payment'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'      |
				| 'Bank payment'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.BankPayment.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205014 add test command to the list of documents BankReceipt
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Bank receipt
		* Create metadata for BankReceipt and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'      |
				| 'Bank receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Bank receipt'            | 'Test command'   |
	* Check the command from the document list BankReceipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'      |
				| 'Bank receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'      |
				| 'Bank receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.BankReceipt.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _0205016 add test command to the list of documents Bundling
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Bundling
		* Create metadata for Bundling and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Bundling'        |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Bundling'                | 'Test command'   |
	* Check the command from the document list Bundling
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Bundling'        |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'     |
				| 'Bundling'        |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.Bundling.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205017 add test command to the list of documents CashExpense
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for CashExpense
		* Create metadata for CashExpense and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash expense'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Cash expense'            | 'Test command'   |
	* Check the command from the document list CashExpense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash expense'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'      |
				| 'Cash expense'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.CashExpense.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _0205018 add test command to the list of documents CashPayment
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Cash payment
		* Create metadata for CashPayment and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash payment'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Cash payment'            | 'Test command'   |
	* Check the command from the document list CashPayment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash payment'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'      |
				| 'Cash payment'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.CashPayment.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205019 add test command to the list of documents Cash Receipt
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Cash Receipt
		* Create metadata for CashReceipt and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Cash receipt'            | 'Test command'   |
	* Check the command from the document list CashReceipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'      |
				| 'Cash receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.CashReceipt.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205020 add test command to the list of documents Cash Revenue
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for CashRevenue
		* Create metadata for CashRevenue and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash revenue'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Cash revenue'            | 'Test command'   |
	* Check the command from the document list CashRevenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash revenue'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'      |
				| 'Cash revenue'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.CashRevenue.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows




Scenario: _0205023 add test command to the list of documents Credit Note
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Credit Note
		* Create metadata for CreditNote and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Credit note'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Credit note'             | 'Test command'   |
	* Check the command from the document list CreditNote
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Credit note'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.CreditNote"
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
				| 'Description'     |
				| 'Credit note'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.CreditNote.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows



Scenario: _0205041 add test command to the list of documents Dedit Note
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Dedit Note
		* Create metadata for DeditNote and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Debit note'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Debit note'              | 'Test command'   |
	* Check the command from the document list DebitNote
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Debit note'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.DebitNote"
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
				| 'Description'     |
				| 'Debit note'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.DebitNote.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205024 add test command to the list of documents Incoming Payment Order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for IncomingPaymentOrder
		* Create metadata for IncomingPaymentOrder and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                |
				| 'Incoming payment order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Incoming payment order'  | 'Test command'   |
	* Check the command from the document list IncomingPaymentOrder
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                |
				| 'Incoming payment order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'                |
				| 'Incoming payment order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.IncomingPaymentOrder.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205025 add test command to the list of documents Internal Supply Request
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for InternalSupplyRequest
		* Create metadata for InternalSupplyRequest and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                 |
				| 'Internal supply request'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'   | 'Plugins'        |
		| 'Internal supply request'  | 'Test command'   |
	* Check the command from the document list InternalSupplyRequest
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                 |
				| 'Internal supply request'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'                 |
				| 'Internal supply request'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.InternalSupplyRequest.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205026 add test command to the list of documents Inventory Transfer
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Inventory Transfer
		* Create metadata for Inventory Transfer and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'            |
				| 'Inventory transfer'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Inventory transfer'      | 'Test command'   |
	* Check the command from the document list InventoryTransfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'            |
				| 'Inventory transfer'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'            |
				| 'Inventory transfer'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.InventoryTransfer.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205027 add test command to the list of documents Inventory Transfer Order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for InventoryTransferOrder
		* Create metadata for InventoryTransferOrder and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                  |
				| 'Inventory transfer order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'    | 'Plugins'        |
		| 'Inventory transfer order'  | 'Test command'   |
	* Check the command from the document list InventoryTransferOrder
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                  |
				| 'Inventory transfer order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'                  |
				| 'Inventory transfer order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.InventoryTransferOrder.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows



Scenario: _0205029 add test command to the list of documents Labeling
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Labeling
		* Create metadata for Labeling and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Labeling'        |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Labeling'                | 'Test command'   |
	* Check the command from the document list Labeling
		Given I open hyperlink "e1cib/list/Document.Labeling"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Labeling'        |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'     |
				| 'Labeling'        |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.Labeling.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205030 add test command to the list of documents Opening Entry
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for OpeningEntry
		* Create metadata for OpeningEntry and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'       |
				| 'Opening entry'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Opening entry'           | 'Test command'   |
	* Check the command from the document list OpeningEntry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
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
				| 'Opening entry'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Opening entry'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.OpeningEntry.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _0205031 add test command to the list of documents Outgoing Payment Order
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for OutgoingPaymentOrder
		* Create metadata for OutgoingPaymentOrder and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                |
				| 'Outgoing payment order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Outgoing payment order'  | 'Test command'   |
	* Check the command from the document list OutgoingPaymentOrder
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                |
				| 'Outgoing payment order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'                |
				| 'Outgoing payment order'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.OutgoingPaymentOrder.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205032 add test command to the list of documents Physical Count By Location
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Physical Count By Location
		* Create metadata for Physical Count By Location and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                    |
				| 'Physical count by location'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'      | 'Plugins'        |
		| 'Physical count by location'  | 'Test command'   |
	* Check the command from the document list PhysicalCountByLocation
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                    |
				| 'Physical count by location'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'                    |
				| 'Physical count by location'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.PhysicalCountByLocation.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205033 add test command to the list of documents Price List
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Price List
		* Create metadata for PriceList and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Price list'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Price list'              | 'Test command'   |
	* Check the command from the document list PriceList
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Price list'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'     |
				| 'Price list'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'         |
				| 'Purchase return'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Purchase return'         | 'Test command'   |
	* Check the command from the document list PurchaseReturn
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'         |
				| 'Purchase return'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'         |
				| 'Purchase return'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.PurchaseReturn.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows



Scenario: _0205037 add test command to the list of documents Unbundling
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Unbundling
		* Create metadata for Unbundling and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Unbundling'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Unbundling'              | 'Test command'   |
	* Check the command from the document list Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Unbundling'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'     |
				| 'Unbundling'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.Unbundling.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205038 add test command to the list of documents Stock Adjustment As Write Off
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for StockAdjustmentAsWriteOff
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                       |
				| 'Stock adjustment as write-off'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'         | 'Plugins'        |
		| 'Stock adjustment as write-off'  | 'Test command'   |
	* Check the command from the document list StockAdjustmentAsWriteOff
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                       |
				| 'Stock adjustment as write-off'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'                       |
				| 'Stock adjustment as write-off'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.StockAdjustmentAsWriteOff.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205039 add test command to the list of documents Stock Adjustment As Surplus
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Stock Adjustment As Surplus
		* Create metadata for Stock Adjustment As Surplus and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                     |
				| 'Stock adjustment as surplus'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins'        |
		| 'Stock adjustment as surplus'  | 'Test command'   |
	* Check the command from the document list StockAdjustmentAsSurplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                     |
				| 'Stock adjustment as surplus'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'                     |
				| 'Stock adjustment as surplus'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.StockAdjustmentAsSurplus.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205040 add test command to the list of documents Physical Inventory
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Physical Inventory
		* Create metadata for Physical Inventory and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'            |
				| 'Physical inventory'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Physical inventory'      | 'Test command'   |
	* Check the command from the document list PhysicalInventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'            |
				| 'Physical inventory'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'            |
				| 'Physical inventory'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.PhysicalInventory.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _0205041 add test command to the list of documents Sales order closing
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Sales order closing
		* Create metadata for Sales order closing and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'             |
				| 'Sales order closing'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Sales order closing'     | 'Test command'   |
	* Check the command from the document list Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'             |
				| 'Sales order closing'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
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
				| 'Description'             |
				| 'Sales order closing'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.SalesOrderClosing.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows



Scenario: _0205042 add test command to the list of documents Planned receipt reservation
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Planned receipt reservation
		* Create metadata for Planned receipt reservationg and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                     |
				| 'Planned receipt reservation'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'       | 'Plugins'        |
		| 'Planned receipt reservation'  | 'Test command'   |
	* Check the command from the document list Planned receipt reservation
		Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                     |
				| 'Planned receipt reservation'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
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
				| 'Description'                     |
				| 'Planned receipt reservation'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.PlannedReceiptReservation.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows





Scenario: _010019 check the operation of the command to open an item list from Item type
	* Open catalog Item type
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description'    |
			| 'Shoes'          |
		And I select current line in "List" table
		And In this window I click command interface button "Items"
	* Filter check by items
		And "List" table contains lines
		| 'Description'  | 'Item type'   |
		| 'Boots'        | 'Shoes'       |
		| 'High shoes'   | 'Shoes'       |
		And "List" table does not contain lines
		| 'Description'  | 'Item type'   |
		| 'Dress'        | 'Shoes'       |
	And I close all client application windows



Scenario: _010025 auto set Unused checkbox for wrong element in the catalog Configuration metadata
	* Open catalog Item type
		Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
		And I go to line in "List" table
			| 'Description'    |
			| 'GoodReceip1'    |
		And I select current line in "List" table
		Then the form attribute named "Unused" became equal to "Yes"
		And I close all client application windows
		
		

Scenario: _010026 add test command to the list of documents Money transfer
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for  Money transfer
		* Create metadata for Money transfer and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'        |
				| 'Money transfer'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Money transfer'          | 'Test command'   |
	* Check the command from the document list Money transfer
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'        |
				| 'Money transfer'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
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
				| 'Description'        |
				| 'Money transfer'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.MoneyTransfer.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows				


Scenario: _010027 add test command to the list of documents Journal entry
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for  JournalEntry
		* Create metadata for JournalEntry and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'       |
				| 'Journal entry'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Journal entry'           | 'Test command'   |
	* Check the command from the document list JournalEntry
		Given I open hyperlink "e1cib/list/Document.JournalEntry"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
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
				| 'Journal entry'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.JournalEntry"
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
				| 'Journal entry'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.JournalEntry.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows	


Scenario: _010028 add test command to the list of documents Item stock adjustment
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for  Item stock adjustment
		* Create metadata for Item stock adjustment and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'               |
				| 'Item stock adjustment'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Item stock adjustment'   | 'Test command'   |
	* Check the command from the document list Item stock adjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'               |
				| 'Item stock adjustment'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
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
				| 'Description'               |
				| 'Item stock adjustment'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.ItemStockAdjustment.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows	
		

Scenario: _010029 add test command to the list of documents CashStatement
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Cash statement
		* Create metadata for Cash statement and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'        |
				| 'Cash statement'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Cash statement'          | 'Test command'   |
	* Check the command from the document Cash statement
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'        |
				| 'Cash statement'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.CashStatement"
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
				| 'Description'        |
				| 'Cash statement'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.CashStatement.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows	
		
Scenario: _010030 add test command to the list of documents Retail sales receipt
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Retail sales receipt
		* Create metadata for Retail sales receipt and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'              |
				| 'Retail sales receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Retail sales receipt'    | 'Test command'   |
	* Check the command from the document Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'              |
				| 'Retail sales receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
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
				| 'Description'              |
				| 'Retail sales receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.RetailSalesReceipt.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _010031 add test command to the list of documents Retail return receipt
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Retail return receipt
		* Create metadata for Retail return receipt and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'               |
				| 'Retail return receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Retail return receipt'   | 'Test command'   |
	* Check the command from the document Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'               |
				| 'Retail return receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
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
				| 'Description'               |
				| 'Retail return receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.RetailReturnReceipt.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _0100310 add test command to the list of documents Purchase order closing
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Purchase order closing
		* Create metadata for Purchase order closing and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                |
				| 'Purchase order closing'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Purchase order closing'  | 'Test command'   |
	* Check the command from the document Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                |
				| 'Purchase order closing'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
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
				| 'Description'                |
				| 'Purchase order closing'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.PurchaseOrderClosing.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _010032 add test command to the list of documents ManualRegisterEntry
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for ManualRegisterEntry
		* Create metadata for ManualRegisterEntry and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'               |
				| 'Manual register entry'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Manual register entry'   | 'Test command'   |
	* Check the command from the document ManualRegisterEntry
		Given I open hyperlink "e1cib/list/Document.ManualRegisterEntry"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'               |
				| 'Manual register entry'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.ManualRegisterEntry"
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
				| 'Description'               |
				| 'Manual register entry'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.ManualRegisterEntry.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows



Scenario: _0205022 add test command to the list of documents Cheque bond transaction
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Cheque bond transaction
		* Create metadata for Cheque bond transaction and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                 |
				| 'Cheque bond transaction'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'   | 'Plugins'        |
		| 'Cheque bond transaction'  | 'Test command'   |
	* Check the command from the document list ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                 |
				| 'Cheque bond transaction'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
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
				| 'Description'                 |
				| 'Cheque bond transaction'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.ChequeBondTransaction.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _010033 add test command to the list of documents Work order
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Work order
		* Create metadata for Work order and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Work order'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Work order'              | 'Test command'   |
	* Check the command from the document Work order
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Work order'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
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
				| 'Description'     |
				| 'Work order'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.WorkOrder.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _010034 add test command to the list of documents Work sheet
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Work sheet
		* Create metadata for Work sheet and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Work sheet'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Work sheet'              | 'Test command'   |
	* Check the command from the document Work sheet
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Work sheet'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
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
				| 'Description'     |
				| 'Work sheet'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.WorkSheet.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _010035 add test command to the list of documents SalesReportFromTradeAgent
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Sales report from trade agent
		* Create metadata for Sales report from trade agent and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                       |
				| 'Sales report from trade agent'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'         | 'Plugins'        |
		| 'Sales report from trade agent'  | 'Test command'   |
	* Check the command from the document Sales report from trade agent
		Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                       |
				| 'Sales report from trade agent'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
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
				| 'Description'                       |
				| 'Sales report from trade agent'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.SalesReportFromTradeAgent.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _010035 add test command to the list of documents SalesReportToConsignor
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Sales report to consignor
		* Create metadata for Sales report to consignor and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                   |
				| 'Sales report to consignor'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'     | 'Plugins'        |
		| 'Sales report to consignor'  | 'Test command'   |
	* Check the command from the document Sales report to consignor
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                   |
				| 'Sales report to consignor'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
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
				| 'Description'                   |
				| 'Sales report to consignor'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.SalesReportToConsignor.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _010036 add test command to the list of documents Payrolls
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Payrolls
		* Create metadata for Payrolls and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Payroll'         |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Payroll'                 | 'Test command'   |
	* Check the command from the document Payrolls
		Given I open hyperlink "e1cib/list/Document.Payroll"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Payroll'         |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.Payroll"
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
				| 'Description'     |
				| 'Payroll'         |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.Payroll.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _010037 add test command to the list of documents TimeSheet
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for TimeSheet
		* Create metadata for TimeSheet and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Time sheet'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Time sheet'              | 'Test command'   |
	* Check the command from the document Time sheet
		Given I open hyperlink "e1cib/list/Document.TimeSheet"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Time sheet'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.TimeSheet"
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
				| 'Description'     |
				| 'Time sheet'      |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.TimeSheet.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205038 add test command to the list of documents Retail Shipment confirmation
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Retail Shipment confirmation
		* Create metadata for Retail Shipment confirmation and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'                      |
				| 'Retail Shipment confirmation'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'        | 'Plugins'        |
		| 'Retail Shipment confirmation'  | 'Test command'   |
	* Check the command from the document list CashTransferOrder
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'                      |
				| 'Retail Shipment confirmation'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
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
				| 'Description'                      |
				| 'Retail Shipment confirmation'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.RetailShipmentConfirmation.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _0205039 add test command to the list of documents Retail goods receipt
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for Retail goods receipt
		* Create metadata for Retail goods receipt and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'              |
				| 'Retail goods receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Retail goods receipt'    | 'Test command'   |
	* Check the command from the document list RetailGoodsReceipt
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'              |
				| 'Retail goods receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
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
				| 'Description'              |
				| 'Retail goods receipt'     |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.RetailGoodsReceipt.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _010050 add test command to the list of documents EmployeeFiring
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for EmployeeFiring
		* Create metadata for EmployeeFiring and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Employee firing' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Employee firing'         | 'Test command'   |
	* Check the command from the document EmployeeFiring
		Given I open hyperlink "e1cib/list/Document.EmployeeFiring"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Employee firing' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.EmployeeFiring"
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
				| 'Description'     |
				| 'Employee firing' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.EmployeeFiring.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows


Scenario: _010051 add test command to the list of documents EmployeeHiring
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for EmployeeHiring
		* Create metadata for EmployeeHiring and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Employee hiring' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Employee hiring'         | 'Test command'   |
	* Check the command from the document EmployeeHiring
		Given I open hyperlink "e1cib/list/Document.EmployeeHiring"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Employee hiring' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.EmployeeHiring"
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
				| 'Description'     |
				| 'Employee hiring' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.EmployeeHiring.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _010052 add test command to the list of documents EmployeeTransfer
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for EmployeeTransfer
		* Create metadata for EmployeeTransfer and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Employee transfer' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Employee transfer'         | 'Test command'   |
	* Check the command from the document EmployeeTransfer
		Given I open hyperlink "e1cib/list/Document.EmployeeTransfer"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Employee transfer' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.EmployeeTransfer"
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
				| 'Description'     |
				| 'Employee transfer' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.EmployeeTransfer.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _010053 add test command to the list of documents EmployeeVacation
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for EmployeeVacation
		* Create metadata for EmployeeVacation and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Employee vacation' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Employee vacation'         | 'Test command'   |
	* Check the command from the document EmployeeVacation
		Given I open hyperlink "e1cib/list/Document.EmployeeVacation"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Employee vacation' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.EmployeeVacation"
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
				| 'Description'     |
				| 'Employee vacation' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.EmployeeVacation.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _010054 add test command to the list of documents EmployeeSickLeave
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for EmployeeSickLeave
		* Create metadata for EmployeeSickLeave and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'     |
				| 'Employee sick leave' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Employee sick leave'         | 'Test command'   |
	* Check the command from the document EmployeeSickLeave
		Given I open hyperlink "e1cib/list/Document.EmployeeSickLeave"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
		And I close all client application windows
	* Connect a command to a document form
		* Open Command register
			Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
			And I click the button named "FormCreate"
		* Filling in command
			And I click Select button of "Configuration metadata" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Employee sick leave' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.EmployeeSickLeave"
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
				| 'Description'     |
				| 'Employee sick leave' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.EmployeeSickLeave.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows

Scenario: _010055 add test command to the list of documents DebitCreditNote
	And I close all client application windows
	* Open Command register
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
	* Filling test command data for DebitCreditNote
		* Create metadata for DebitCreditNote and select it for the command
			And I click Select button of "Configuration metadata" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'       |
				| 'Debit/Credit note' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "List form" exact value from "Form type" drop-down list
	* Save command
		And I click "Save and close" button
	* Check command save
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And "List" table contains lines
		| 'Configuration metadata'  | 'Plugins'        |
		| 'Debit/Credit note'       | 'Test command'   |
	* Check the command from the document DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to the last line in "List" table
		And I click "Test command" button
		Then I wait that in user messages the "Success client" substring will appear in 10 seconds
		Then I wait that in user messages the "Success server" substring will appear in 10 seconds
	* Check that the command is not displayed in the document
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click "Test command" button'    |
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
				| 'Debit/Credit note' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Object form" exact value from "Form type" drop-down list
			And I click "Save and close" button
	* Check that the command is displayed in the document
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
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
				| 'Debit/Credit note' |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Test command'     |
			And I select current line in "List" table
			And I select "Choice form" exact value from "Form type" drop-down list
			And I click "Save and close" button
		* Check that the command is displayed in the choice form
			And I execute the built-in language code (Extension)
				| 'OpenForm("Document.DebitCreditNote.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'     |
			And I click "Test command" button
			Then I wait that in user messages the "Success client" substring will appear in 10 seconds
			Then I wait that in user messages the "Success server" substring will appear in 10 seconds
		And I close all client application windows