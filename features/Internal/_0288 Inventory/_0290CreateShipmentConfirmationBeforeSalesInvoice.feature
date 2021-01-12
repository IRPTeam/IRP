#language: en
@tree
@Positive
@Inventory

Feature: posting shipment confirmation before Sales invoice

As a sales manager
I want to create Shipment confirmation before Sales invoice
To sell a product when customer first receives items and then the documents arrive at him.


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _029000 preparation (posting shipment confirmation before Sales invoice)
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
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
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

Scenario: _029001 partner setup Shipment confirmation before Sales invoice
	* Check partner setup Shipment confirmation before Sales invoice
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| Description |
			| Kalipso   |
		And I select current line in "List" table
		And I set checkbox "Shipment confirmations before sales invoice"
		Then the form attribute named "ShipmentConfirmationsBeforeSalesInvoice" became equal to "Yes"
		And I click "Save and close" button

Scenario: _029002 create document Sales order and Shipment confirmation (partner Kalipso, Store use Shipment confirmation)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'Kalipso' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Shirt' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Red'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Trousers' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '36/Yellow'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "12,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberSalesOrder029002$$" variable
	And I delete "$$SalesOrder029002$$" variable
	And I save the value of "Number" field as "$$NumberSalesOrder029002$$"
	And I save the window as "$$SalesOrder029002$$"
	* Create Shipment confirmation
		And I click "Shipment confirmation" button
		Then the form attribute named "Company" became equal to "Main Company"
	* Check that the tabular part is filled in
		And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Store'    | 'Unit' | 'Shipment basis'   |
			| 'Trousers' | '12,000'   | '36/Yellow' | 'Store 02' | 'pcs' | '$$SalesOrder029002$$' |
			| 'Shirt'    | '10,000'   | '36/Red'    | 'Store 02' | 'pcs' | '$$SalesOrder029002$$' |
	And I click the button named "FormPost"
	And I delete "$$NumberShipmentConfirmation029002$$" variable
	And I delete "$$ShipmentConfirmation029002$$" variable
	And I save the value of "Number" field as "$$NumberShipmentConfirmation029002$$"
	And I save the window as "$$ShipmentConfirmation029002$$"
	And I click the button named "FormPostAndClose"
	And I close all client application windows

Scenario: _029003 check Sales order posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register OrderBalance
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'             | 'Store'    | 'Order'                | 'Item key'  |
		| '12,000'   | '$$SalesOrder029002$$' | 'Store 02' | '$$SalesOrder029002$$' | '36/Yellow' |
		| '10,000'   | '$$SalesOrder029002$$' | 'Store 02' | '$$SalesOrder029002$$' | '36/Red'    |
	And I close all client application windows

Scenario: _029004 check Sales order posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register StockReservation
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key'  |
		| '12,000'   | '$$SalesOrder029002$$' | 'Store 02' | '36/Yellow' |
		| '10,000'   | '$$SalesOrder029002$$' | 'Store 02' | '36/Red'    |
	And I close all client application windows

Scenario: _029005 check Sales order posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register InventoryBalance
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'             | 'Company'      | 'Item key'  |
		| '12,000'   | '$$SalesOrder029002$$' | 'Main Company' | '36/Yellow' |
		| '10,000'   | '$$SalesOrder029002$$' | 'Main Company' | '36/Red'    |
	And I close all client application windows

Scenario: _029006 check Sales order posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register GoodsInTransitOutgoing
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'             | 'Shipment basis'       | 'Store'    | 'Item key'  |
		| '12,000'   | '$$SalesOrder029002$$' | '$$SalesOrder029002$$' | 'Store 02' | '36/Yellow' |
		| '10,000'   | '$$SalesOrder029002$$' | '$$SalesOrder029002$$' | 'Store 02' | '36/Red'    |
	And I close all client application windows

Scenario: _029007 check the absence posting of Sales order (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register StockBalance
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
		| 'Recorder'         |
		| '$$SalesOrder029002$$' |
	And I close all client application windows

Scenario: _029008 check the absence posting of Sales order (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register ShipmentOrders
	Given I open hyperlink "e1cib/list/AccumulationRegister.ShipmentOrders"
	And "List" table does not contain lines
		| 'Recorder'         |
		| '$$SalesOrder029002$$' |
	And I close all client application windows

Scenario: _029009 check Shipment confirmation posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register StockBalance
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                       | 'Store'    | 'Item key'  |
		| '12,000'   | '$$ShipmentConfirmation029002$$' | 'Store 02' | '36/Yellow' |
		| '10,000'   | '$$ShipmentConfirmation029002$$' | 'Store 02' | '36/Red'    |
	And I close all client application windows

Scenario: _029010 check Shipment confirmation posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register GoodsInTransitOutgoing
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                       | 'Shipment basis'       | 'Store'    | 'Item key'  |
		| '12,000'   | '$$ShipmentConfirmation029002$$' | '$$SalesOrder029002$$' | 'Store 02' | '36/Yellow' |
		| '10,000'   | '$$ShipmentConfirmation029002$$' | '$$SalesOrder029002$$' | 'Store 02' | '36/Red'    |
	And I close all client application windows

Scenario: _029011 check Shipment confirmation posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register ShipmentOrders
	Given I open hyperlink "e1cib/list/AccumulationRegister.ShipmentOrders"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                       | 'Order'                | 'Shipment confirmation'          | 'Item key'  |
		| '12,000'   | '$$ShipmentConfirmation029002$$' | '$$SalesOrder029002$$' | '$$ShipmentConfirmation029002$$' | '36/Yellow' |
		| '10,000'   | '$$ShipmentConfirmation029002$$' | '$$SalesOrder029002$$' | '$$ShipmentConfirmation029002$$' | '36/Red'    |
	And I close all client application windows

Scenario: _029012 create document Sales order and Shipment confirmation (partner Kalipso, one Store use Shipment confirmation and Second not)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'Kalipso' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Shirt' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Red'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Trousers' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '36/Yellow'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "12,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Change of quantity and store on the second line
		And I select current line in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| Item     | Item key  |
			| Trousers | 36/Yellow |
		And I select current line in "ItemList" table
		And I input "7,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListStore" in "ItemList" table
		And I click choice button of "Store" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Store 01  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberSalesOrder029012$$" variable
		And I delete "$$SalesOrder029012$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029012$$"
		And I save the window as "$$SalesOrder029012$$"
	* Create Shipment confirmation
		And I click "Shipment confirmation" button
		Then the form attribute named "Company" became equal to "Main Company"
		And "ItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Item key' | 'Store'    | 'Unit' | 'Shipment basis'       |
			| 'Shirt' | '10,000'   | '36/Red'   | 'Store 02' | 'pcs'  | '$$SalesOrder029012$$' |
		And I click the button named "FormPost"
		And I delete "$$NumberShipmentConfirmation029012$$" variable
		And I delete "$$ShipmentConfirmation029012$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029012$$"
		And I save the window as "$$ShipmentConfirmation029012$$"
		And I click the button named "FormPostAndClose"
	And I close all client application windows
	* Check movements by register OrderBalance
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'             | 'Store'    | 'Order'                | 'Item key'  |
			| '7,000'    | '$$SalesOrder029012$$' | 'Store 01' | '$$SalesOrder029012$$' | '36/Yellow' |
			| '10,000'   | '$$SalesOrder029012$$' | 'Store 02' | '$$SalesOrder029012$$' | '36/Red'    |
		And I close all client application windows
	* Check movements by register StockReservation
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key'  |
			| '7,000'    | '$$SalesOrder029012$$' | 'Store 01' | '36/Yellow' |
			| '10,000'   | '$$SalesOrder029012$$' | 'Store 02' | '36/Red'    |
		And I close all client application windows
	* Check movements by register InventoryBalance
		Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'             | 'Company'      | 'Item key'  |
			| '7,000'    | '$$SalesOrder029012$$' | 'Main Company' | '36/Yellow' |
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'         |'Company'      | 'Item key'  |
			| '10,000'   | '$$SalesOrder029012$$' |'Main Company' | '36/Red'    |
		And I close all client application windows
	* Check movements by register GoodsInTransitOutgoing
		Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'         | 'Shipment basis'   | 'Line number' | 'Store'    | 'Item key' |
			| '10,000'   | '$$SalesOrder029012$$' | '$$SalesOrder029012$$' | '1'           | 'Store 02' | '36/Red'   |
		And I close all client application windows
	* Check movements by register StockBalance
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'         | 'Line number' | 'Store'    | 'Item key'  |
			| '7,000'    | '$$SalesOrder029012$$' | '1'           | 'Store 01' | '36/Yellow' |
		And I close all client application windows
	* Check movements by register ShipmentOrders
		Given I open hyperlink "e1cib/list/AccumulationRegister.ShipmentOrders"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'         | 'Line number' | 'Order'            | 'Shipment confirmation'  | 'Item key'  |
			| '7,000'    | '$$SalesOrder029012$$' | '1'           | '$$SalesOrder029012$$' | '$$SalesOrder029012$$'       | '36/Yellow' |
		And I close all client application windows
	* Check movements by register StockBalance
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                   | 'Line number' | 'Store'    | 'Item key' |
			| '10,000'   | '$$ShipmentConfirmation029012$$' | '1'           | 'Store 02' | '36/Red'   |
		And I close all client application windows
	* Check movements by register GoodsInTransitOutgoing
		Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                   | 'Shipment basis'   | 'Line number' | 'Store'    | 'Item key' |
			| '10,000'   | '$$ShipmentConfirmation029012$$' | '$$SalesOrder029012$$' | '1'           | 'Store 02' | '36/Red'   |
		And I close all client application windows
	* Check movements by register ShipmentOrders
		Given I open hyperlink "e1cib/list/AccumulationRegister.ShipmentOrders"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                   | 'Line number' | 'Order'            | 'Shipment confirmation'      | 'Item key' |
			| '10,000'   | '$$ShipmentConfirmation029012$$' | '1'           | '$$SalesOrder029012$$' | '$$ShipmentConfirmation029012$$' | '36/Red'   |
		And I close all client application windows
	
Scenario: _029013 create Sales invoice for several shipments
# one shipment can apply to only one Sales invoice
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
		| 'Number'                     | 'Partner' |
		| '$$NumberSalesOrder029002$$' | 'Kalipso' |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
	And I click the button named "FormSelectAll"
	And I click "Ok" button
	Then the form attribute named "Partner" became equal to "Kalipso"
	Then the form attribute named "LegalName" became equal to "Company Kalipso"
	Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
	Then the form attribute named "Company" became equal to "Main Company"
	And I go to line in "ItemList" table
    	| 'Item'     | 'Item key'  | 'Store'    | 'Unit' | 'Q'      |
		| 'Trousers' | '36/Yellow' | 'Store 01' | 'pcs'  | '7,000'  |
	And I delete a line in "ItemList" table
	* Check the filling of the tabular part
		And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Sales order'          | 'Unit' | 'Q'      | 'Offers amount' | 'Tax amount' | 'Net amount' | 'Total amount' |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '$$SalesOrder029002$$' | 'pcs'  | '12,000' | ''              | '732,20'     | '4 067,76'   | '4 799,96'     |
		| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '$$SalesOrder029002$$' | 'pcs'  | '10,000' | ''              | '533,90'     | '2 966,10'   | '3 500,00'     |
		| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '$$SalesOrder029002$$' | 'pcs'  | '10,000' | ''              | '533,90'     | '2 966,10'   | '3 500,00'     |
	And I click the button named "FormPost"
	And I delete "$$NumberSalesInvoice029013$$" variable
	And I delete "$$SalesInvoice029013$$" variable
	And I save the value of "Number" field as "$$NumberSalesInvoice029013$$"
	And I save the window as "$$SalesInvoice029013$$"
	And I click the button named "FormPostAndClose"
	And Delay 5
	* Check movements
		* Check the absence posting by register Stock Balance
			Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$SalesInvoice029013$$' |
			And I close all client application windows
		* Check the absence posting by register Inventory Balance 
			Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$SalesInvoice029013$$' |
			And I close all client application windows
		* Check the absence posting by register Stock StockReservation
			Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$SalesInvoice029013$$' |
			And I close all client application windows
		* Check the absence posting by register GoodsInTransitOutgoing
			Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$SalesInvoice029013$$' |
			And I close all client application windows
		* Check posting by register Order Balance
			Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
			And "List" table contains lines
				| 'Quantity' | 'Recorder'               | 'Store'    | 'Order'                | 'Item key'  |
				| '12,000'   | '$$SalesInvoice029013$$' | 'Store 02' | '$$SalesOrder029002$$' | '36/Yellow' |
				| '10,000'   | '$$SalesInvoice029013$$' | 'Store 02' | '$$SalesOrder029002$$' | '36/Red'    |
				| '10,000'   | '$$SalesInvoice029013$$' | 'Store 02' | '$$SalesOrder029012$$' | '36/Red'    |
			And I close all client application windows
		* Check posting by register OrderReservation
			Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
			And "List" table contains lines
				| 'Quantity' | 'Recorder'               | 'Store'    | 'Item key'  |
				| '12,000'   | '$$SalesInvoice029013$$' | 'Store 02' | '36/Yellow' |
				| '20,000'   | '$$SalesInvoice029013$$' | 'Store 02' | '36/Red'    |
			And I close all client application windows
		* Check posting by register OrderReservation
			Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
			And "List" table contains lines
				| 'Quantity' | 'Recorder'               | 'Sales invoice'          | 'Item key'  |
				| '12,000'   | '$$SalesInvoice029013$$' | '$$SalesInvoice029013$$' | '36/Yellow' |
				| '10,000'   | '$$SalesInvoice029013$$' | '$$SalesInvoice029013$$' | '36/Red'    |
				| '10,000'   | '$$SalesInvoice029013$$' | '$$SalesInvoice029013$$' | '36/Red'    |
			And I close all client application windows
		* Check posting by register ShipmentOrders
			Given I open hyperlink "e1cib/list/AccumulationRegister.ShipmentOrders"
			And "List" table contains lines
				| 'Quantity' | 'Recorder'               | 'Order'                | 'Shipment confirmation'          | 'Item key'  |
				| '12,000'   | '$$SalesInvoice029013$$' | '$$SalesOrder029002$$' | '$$ShipmentConfirmation029002$$' | '36/Yellow' |
				| '10,000'   | '$$SalesInvoice029013$$' | '$$SalesOrder029002$$' | '$$ShipmentConfirmation029002$$' | '36/Red'    |
				| '10,000'   | '$$SalesInvoice029013$$' | '$$SalesOrder029012$$' | '$$ShipmentConfirmation029012$$' | '36/Red'    |
			And I close all client application windows

Scenario: _029014 availability check for selection shipment confirmation for which sales invoice has already been issued
# should not be displayed
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
		| 'Number' | 'Partner'     |
		| '$$NumberSalesOrder029002$$'    | 'Kalipso' |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
	And I click the button named "FormSelectAll"
	And I click "Ok" button
	* Filling check
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
		Then the form attribute named "Company" became equal to "Main Company"
	* Check the filling of the tabular part
		And I save number of "ItemList" table lines as "Q"
		And I display "Q" variable value
		Then "Q" variable is equal to 1
		And "ItemList" table contains lines
			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Sales order'      | 'Unit' | 'Q'     | 'Offers amount' | 'Tax amount' | 'Net amount' | 'Total amount' |
			| 'Trousers' | '338,98' | '36/Yellow' | 'Store 01' | '$$SalesOrder029012$$' | 'pcs' | '7,000' | ''              | '427,11'     | '2 372,86'   | '2 799,97'     |
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice029014$$" variable
		And I delete "$$SalesInvoice029014$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029014$$"
		And I save the window as "$$SalesInvoice029014$$"
		And I click the button named "FormPostAndClose"
	And I close all client application windows
	* Check movements
		* Check the absence posting by register Stock Balance
			Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$SalesInvoice029014$$' |
			And I close all client application windows
		* Check the absence posting by register Inventory Balance 
			Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$SalesInvoice029014$$' |
			And I close all client application windows
		* Check the absence posting by register Stock StockReservation
			Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$SalesInvoice029014$$' |
			And I close all client application windows
		* Check the absence posting by register GoodsInTransitOutgoing
			Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$SalesInvoice029014$$' |
			And I close all client application windows
		* Check posting by register Order Balance
			Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
			And "List" table contains lines
				| 'Recorder'           |
				| '$$SalesInvoice029014$$' |
			And I close all client application windows
		* Check posting by register Order reservation
			Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
			And "List" table contains lines
				| 'Recorder'           |
				| '$$SalesInvoice029014$$' |
			And I close all client application windows
		* Check posting by register Sales turnovers
			Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
			And "List" table contains lines
				| 'Recorder'           |
				| '$$SalesInvoice029014$$' |
			And I close all client application windows
		* Check posting by register ShipmentOrders
			Given I open hyperlink "e1cib/list/AccumulationRegister.ShipmentOrders"
			And "List" table contains lines
				| 'Recorder'           |
				| '$$SalesInvoice029014$$' |
			And I close all client application windows
