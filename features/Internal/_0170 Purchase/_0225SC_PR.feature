#language: en
@tree
@Positive
@Purchase

Functionality: Shipment confirmation - Purchase return



Scenario: _022500 preparation (SC-PR)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
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
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
		When Create document PurchaseInvoice objects
		When Create catalog PriceTypes objects
		

Scenario: _022501 create SC with transaction type return to vendor and create Purchase return
	* Open form SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
		And I select "Return to vendor" exact value from "Transaction type" drop-down list
	* Filling in main info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'|
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'     |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Filling in items info
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '36/Yellow' |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$ShipmentConfirmation022501$$" variable
		And I delete "$$NumberShipmentConfirmation022501$$" variable
		And I delete "$$DateShipmentConfirmation022501$$" variable
		And I save the window as "$$ShipmentConfirmation022501$$"
		And I save the value of "Number" field as "$$NumberShipmentConfirmation022501$$"
		And I save the value of "Date" field as "$$DateShipmentConfirmation022501$$"
		And I close current window
	* Create PR
		And I click "Purchase return" button
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Q'     | 'Unit' |
			| 'Trousers' | '36/Yellow' | '1,000' | 'pcs'  |
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                      |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		* Select PI
			And I select current line in "ItemList" table
			And I click choice button of "Purchase invoice" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Company'      | 'Currency' | 'Date'                | 'Legal name'      | 'Partner' |
				| 'Main Company' | 'TRY'      | '07.09.2020 17:53:38' | 'Company Ferron BP' | 'Ferron BP' |
			And I select current line in "List" table			
		And I click "Post" button
		And I delete "$$PurchaseReturn022501$$" variable
		And I delete "$$NumberPurchaseReturn022501$$" variable
		And I delete "$$DatePurchaseReturn022501$$" variable
		And I save the window as "$$PurchaseReturn022501$$"
		And I save the value of "Number" field as "$$NumberPurchaseReturn022501$$"
		And I save the value of "Date" field as "$$DatePurchaseReturn022501$$"
		And I close current window
		
			
Scenario: _028402 check SC - PR movements
	* GR movements
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'                      |
			| '$$NumberShipmentConfirmation022501$$' |
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines
			| '$$ShipmentConfirmation022501$$'       | ''            | ''                                   | ''          | ''             | ''         | ''                               | ''          |
			| 'Document registrations records'       | ''            | ''                                   | ''          | ''             | ''         | ''                               | ''          |
			| 'Register  "R2031 Shipment invoicing"' | ''            | ''                                   | ''          | ''             | ''         | ''                               | ''          |
			| ''                                     | 'Record type' | 'Period'                             | 'Resources' | 'Dimensions'   | ''         | ''                               | ''          |
			| ''                                     | ''            | ''                                   | 'Quantity'  | 'Company'      | 'Store'    | 'Basis'                          | 'Item key'  |
			| ''                                     | 'Receipt'     | '$$DateShipmentConfirmation022501$$' | '1'         | 'Main Company' | 'Store 02' | '$$ShipmentConfirmation022501$$' | '36/Yellow' |
		And I select "Stock reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines
			| '$$ShipmentConfirmation022501$$' | ''            | ''                                   | ''          | ''           | ''          |
			| 'Document registrations records' | ''            | ''                                   | ''          | ''           | ''          |
			| 'Register  "Stock reservation"'  | ''            | ''                                   | ''          | ''           | ''          |
			| ''                               | 'Record type' | 'Period'                             | 'Resources' | 'Dimensions' | ''          |
			| ''                               | ''            | ''                                   | 'Quantity'  | 'Store'      | 'Item key'  |
			| ''                               | 'Expense'     | '$$DateShipmentConfirmation022501$$' | '1'         | 'Store 02'   | '36/Yellow' |
		And I select "Stock balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines
			| '$$ShipmentConfirmation022501$$' | ''            | ''                                   | ''          | ''           | ''          |
			| 'Document registrations records' | ''            | ''                                   | ''          | ''           | ''          |
			| 'Register  "Stock balance"'      | ''            | ''                                   | ''          | ''           | ''          |
			| ''                               | 'Record type' | 'Period'                             | 'Resources' | 'Dimensions' | ''          |
			| ''                               | ''            | ''                                   | 'Quantity'  | 'Store'      | 'Item key'  |
			| ''                               | 'Expense'     | '$$DateShipmentConfirmation022501$$' | '1'         | 'Store 02'   | '36/Yellow' |
		And I close all client application windows
	* PR movements
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'                      |
			| '$$NumberPurchaseReturn022501$$' |
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines
			| '$$PurchaseReturn022501$$'             | ''            | ''                             | ''          | ''             | ''         | ''                               | ''          |
			| 'Document registrations records'       | ''            | ''                             | ''          | ''             | ''         | ''                               | ''          |
			| 'Register  "R2031 Shipment invoicing"' | ''            | ''                             | ''          | ''             | ''         | ''                               | ''          |
			| ''                                     | 'Record type' | 'Period'                       | 'Resources' | 'Dimensions'   | ''         | ''                               | ''          |
			| ''                                     | ''            | ''                             | 'Quantity'  | 'Company'      | 'Store'    | 'Basis'                          | 'Item key'  |
			| ''                                     | 'Expense'     | '$$DatePurchaseReturn022501$$' | '1'         | 'Main Company' | 'Store 02' | '$$ShipmentConfirmation022501$$' | '36/Yellow' |
		And I select "Stock reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "Stock reservation"'             |
		And I select "Stock balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "Stock balance"'             |
		And I close all client application windows