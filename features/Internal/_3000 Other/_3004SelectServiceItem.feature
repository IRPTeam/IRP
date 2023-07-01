#language: en
@tree
@Positive
@Other


Feature: product / service selection filter

As a developer
I want to add a product/service filter.
For the convenience of adding items to the purchase and transfer documents


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _300400 preparation (product / service selection filter)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When update ItemKeys

Scenario: _3004001 check preparation
	When check preparation



# services available

Scenario: _300401 check filter on the choice of services in the document Purchase order
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table contains lines
		| Description   |
		| Dress TR      |
		| Service TR    |
		| Router        |
	And I close all client application windows

Scenario: _300402 check filter on the choice of services in the document Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table contains lines
		| Description   |
		| Dress TR      |
		| Service TR    |
		| Router        |
	And I close all client application windows

Scenario: _300403 check filter on the choice of services in the document Sales order
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table contains lines
		| Description   |
		| Dress TR      |
		| Service TR    |
		| Router        |
	And I close all client application windows


Scenario: _300404 check filter on the choice of services in the document Sales invoice
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table contains lines
		| Description   |
		| Dress TR      |
		| Service TR    |
		| Router        |
	And I close all client application windows

# services not available

Scenario: _300405 check filter on the choice of services in the document Inventory transfer
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table does not contain lines
		| Description   |
		| Service TR    |
	And I close all client application windows

Scenario: _300406 check filter on the choice of services in the document Inventory transfer order
	Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table does not contain lines
		| Description   |
		| Service TR    |
	And I close all client application windows

Scenario: _300407 check filter on the choice of services in the document Internal Supply Request
	Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table contains lines
		| Description   |
		| Dress TR      |
		| Router        |
	And I close all client application windows

Scenario: _300408 check filter on the choice of services in the document Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table contains lines
		| Description   |
		| Dress TR      |
		| Service TR    |
		| Router        |
	And I close all client application windows

Scenario: _300409 check filter on the choice of services in the document Purchase return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table contains lines
		| Description   |
		| Dress TR      |
		| Service TR    |
		| Router        |
	And I close all client application windows

Scenario: _300410 check filter on the choice of services in the document Sales Return
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table contains lines
		| Description   |
		| Dress TR      |
		| Service TR    |
		| Router        |
	And I close all client application windows

Scenario: _300411 check filter on the choice of services in the document Sales return order
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	And I click the button named "FormCreate"
	And I click "Add" button
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table contains lines
		| Description   |
		| Dress TR      |
		| Service TR    |
		| Router        |
	And I close all client application windows

Scenario: _300412 check filter on the choice of services in the document GoodsReceipt
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	And I click the button named "FormCreate"
	And I click "Add" button
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table does not contain lines
		| Description   |
		| Service TR    |
	And I close all client application windows

Scenario: _300413 check filter on the choice of services in the document Shipment Confirmation
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table does not contain lines
		| Description   |
		| Service TR    |
	And I close all client application windows


Scenario: _300416 check filter on the choice of services in the document Bundling
	Given I open hyperlink "e1cib/list/Document.Bundling"
	And I click the button named "FormCreate"
	And I click Select button of "Item bundle" field
	Then "Items" window is opened
	And "List" table does not contain lines
		| Description   |
		| Service TR    |
	And I close "Items" window
	And I move to "Item list" tab
	And in the table "ItemList" I click "Add" button
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table does not contain lines
		| Description   |
		| Service TR    |
	And I close all client application windows

Scenario: _300417 check filter on the choice of services in the document Unbundling
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	And I click the button named "FormCreate"
	And I click Select button of "Item bundle" field
	Then "Items" window is opened
	And "List" table does not contain lines
		| Description   |
		| Service TR    |
	And I close "Items" window
	And I move to "Item list" tab
	And in the table "ItemList" I click "Add" button
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table does not contain lines
		| Description   |
		| Service TR    |
	And I close all client application windows

Scenario: _300418 check filter on the choice of services in the document StockAdjustmentAsSurplus
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
	And I click the button named "FormCreate"
	And I click "Add" button
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table does not contain lines
		| Description   |
		| Service TR    |
	And I close all client application windows

Scenario: _300419 check filter on the choice of services in the document StockAdjustmentAsWriteOff
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
	And I click the button named "FormCreate"
	And I click "Add" button
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table does not contain lines
		| Description   |
		| Service TR    |
	And I close all client application windows

Scenario: _300420 check filter on the choice of services in the document PhysicalInventory
	Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
	And I click the button named "FormCreate"
	And I click "Add" button
	And I click choice button of "Item" attribute in "ItemList" table
	And "List" table does not contain lines
		| Description   |
		| Service TR    |
	And I close all client application windows
