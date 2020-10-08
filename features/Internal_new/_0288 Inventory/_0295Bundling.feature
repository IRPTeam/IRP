#language: en
@tree
@Positive
@Inventory

Feature: Bundling

As a sales manager
I want to create Bundle
For joint sale of products


Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _029500 preparation (Bundling)
	* Load info
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Companies objects (Main company)
	


Scenario: _029501 create Bundling (Store doesn't use Shipment confirmation and Goods receipt)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Bundling"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
	And I select current line in "List" table
	And I click Select button of "Item bundle" field
	And I go to line in "List" table
		| 'Description'       |
		| 'Scarf + Dress' |
	And I select current line in "List" table
	And I click Choice button of the field named "Unit"
	And I select current line in "List" table
	And I click Select button of "Store" field
	And I go to line in "List" table
		| 'Description' |
		| 'Store 01'  |
	And I select current line in "List" table
	And I input "10,000" text in the field named "Quantity"
	And I move to "Item list" tab
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description' |
		| 'Dress'       |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item'  | 'Item key' |
		| 'Dress' | 'XS/Blue'  |
	And I select current line in "List" table
	And I activate field named "ItemListQuantity" in "ItemList" table
	And I input "1,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description' |
		| 'Scarf'       |
	And I select current line in "List" table
	And I activate field named "ItemListQuantity" in "ItemList" table
	And I input "1,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I save the value of "Number" field as "$$NumberBundling0029501$$"
	And I save the window as "$$Bundling0029501$$"
	And I click the button named "FormPostAndClose"
	And Delay 5

Scenario: _029502 check the automatic creation of the Bundle specification
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.Specifications"
	And I go to line in "List" table
		| 'Description' | 'Type'   |
		| 'Dress+Scarf' | 'Bundle' |
	And I select current line in "List" table
	Then the form attribute named "Type" became equal to "Bundle"
	Then the form attribute named "ItemBundle" became equal to "Scarf + Dress"
	And "FormTable*" table contains lines
		| 'Size' | 'Color' | 'Quantity' |
		| 'XS'   | 'Blue'  | '1,000'    |
	And I close current window

Scenario: _029503 check Bundling posting (store doesn't use Shipment confirmation and Goods receipt) by register StockBalance
# In this case a Bandle is received by register and the goods from the Bandle are written off
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key'                      |
	| '10,000'   | '$$Bundling0029501$$' | 'Store 01' | 'Scarf + Dress/Dress+Scarf' |
	| '10,000'   | '$$Bundling0029501$$' | 'Store 01' | 'XS/Blue'                       |
	| '10,000'   | '$$Bundling0029501$$' | 'Store 01' | 'XS/Red'                        |
	And I close all client application windows

Scenario: _029504 check Bundling posting (store doesn't use Shipment confirmation and Goods receipt) by register StockReservation
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key'                      |
	| '10,000'   | '$$Bundling0029501$$' | 'Store 01' | 'Scarf + Dress/Dress+Scarf' |
	| '10,000'   | '$$Bundling0029501$$' | 'Store 01' | 'XS/Blue'                       |
	| '10,000'   | '$$Bundling0029501$$' | 'Store 01' | 'XS/Red'                        |
	And I close all client application windows

Scenario: _029505 check the absence posting of Bundling (store doesn't use Shipment confirmation and Goods receipt) by register GoodsInTransitIncoming
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table does not contain lines
		| 'Recorder'                 |
		| '$$Bundling0029501$$'              |
	And I close all client application windows

Scenario: _029506 check the absence posting of Bundling (store doesn't use Shipment confirmation and Goods receipt) by register GoodsInTransitOutgoing
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table does not contain lines
		| 'Recorder'                 |
		| '$$Bundling0029501$$'              |
	And I close all client application windows

Scenario: _029507 create Bundling ( Store use Shipment confirmation and Goods receipt)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Bundling"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
	And I select current line in "List" table
	And I click Select button of "Item bundle" field
	And I go to line in "List" table
		| 'Description'       |
		| 'Scarf + Dress' |
	And I select current line in "List" table
	And I click Choice button of the field named "Unit"
	And I select current line in "List" table
	And I click Select button of "Store" field
	And I go to line in "List" table
		| 'Description' |
		| 'Store 02'  |
	And I select current line in "List" table
	And I input "7,000" text in the field named "Quantity"
	And I move to "Item list" tab
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description' |
		| 'Dress'       |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item'  | 'Item key' |
		| 'Dress' | 'XS/Blue'  |
	And I select current line in "List" table
	And I activate field named "ItemListQuantity" in "ItemList" table
	And I input "2,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description' |
		| 'Trousers'       |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item key'  |
		| '36/Yellow' |
	And I select current line in "List" table
	And I activate field named "ItemListQuantity" in "ItemList" table
	And I input "2,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I save the value of "Number" field as "$$NumberBundling0029507$$"
	And I save the window as "$$Bundling0029507$$"
	And I click the button named "FormPostAndClose"
	And Delay 5

Scenario: _029508 check the automatic creation of an additional specification for the created Bundle
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.Specifications"
	And I go to line in "List" table
		| 'Description' | 'Type'   |
		| 'Dress+Trousers' | 'Bundle' |
	And I select current line in "List" table
	Then the form attribute named "Description_en" became equal to "Dress+Trousers"
	Then the form attribute named "Type" became equal to "Bundle"
	Then the form attribute named "ItemBundle" became equal to "Bound Dress+Trousers"
	And "FormTable*" table contains lines
		| 'Size' | 'Color' | 'Quantity' |
		| 'XS'   | 'Blue'  | '2*'    |
	And I close all client application windows



Scenario: _029509 check the absence posting of Bundling (store use Shipment confirmation and Goods receipt) by register StockBalance
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key'             |
		| '7,000'    | '$$Bundling0029507$$' | 'Store 02' | 'Scarf + Dress' |
		| '14,000'   | '$$Bundling0029507$$' | 'Store 02' | 'XS/Blue'              |
		| '14,000'   | '$$Bundling0029507$$' | 'Store 02' | '36/Yellow'           |
	And I close all client application windows

Scenario: _029510 check Bundling posting (store use Shipment confirmation and Goods receipt) by register StockReservation
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key'  |
		| '14,000'   | '$$Bundling0029507$$' | 'Store 02' | 'XS/Blue'   |
		| '14,000'   | '$$Bundling0029507$$' | 'Store 02' | '36/Yellow' |
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key'             |
		| '7,000'    | '$$Bundling0029507$$' | 'Store 02' | 'Scarf + Dress'' |
	And I close all client application windows

Scenario: _029511 check Bundling posting (store use Shipment confirmation and Goods receipt) by register GoodsInTransitIncoming
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'            | 'Receipt basis'       | 'Store'    | 'Item key'                            |
		| '7,000'    | '$$Bundling0029507$$' | '$$Bundling0029507$$' | 'Store 02' | 'Scarf + Dress/Dress+Trousers' |
	And I close all client application windows

Scenario: _029512 check Bundling posting (store use Shipment confirmation and Goods receipt) by register GoodsInTransitOutgoing
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'            | 'Shipment basis'      | 'Store'    | 'Item key'  |
	| '14,000'   | '$$Bundling0029507$$' | '$$Bundling0029507$$' | 'Store 02' | 'XS/Blue'   |
	| '14,000'   | '$$Bundling0029507$$' | '$$Bundling0029507$$' | 'Store 02' | '36/Yellow' |
	And I close all client application windows

Scenario: _029513 create Shipment confirmation and Goods receipt based on Bundling
	Given I open hyperlink "e1cib/list/Document.Bundling"
	And I go to line in "List" table
		| 'Item bundle'          | 'Number' |
		| 'Scarf + Dress' | '$$NumberBundling0029507$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
	Then the form attribute named "Company" became equal to "Main Company"
	And I click the button named "FormPost"
	And I save the value of "Number" field as "$$NumberGoodsReceipt0029513$$"
	And I save the window as "$$GoodsReceipt0029513$$"
	And I click the button named "FormPostAndClose"
	And Delay 5
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	Then the form attribute named "Company" became equal to "Main Company"
	// And I input "151" text in "Number" field
	// Then "1C:Enterprise" window is opened
	// And I click "Yes" button
	// And I input "151" text in "Number" field
	And I click the button named "FormPost"
	And I save the value of "Number" field as "$$NumberShipmentConfirmation0029513$$"
	And I save the window as "$$ShipmentConfirmation0029513$$"
	And I click the button named "FormPostAndClose"
	And Delay 5
	And I close current window

Scenario: _029514 check Shipment confirmation and Goods receipt movements based on document Bundling
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                        | 'Store'    | 'Item key'                            |
		| '7,000'    | '$$GoodsReceipt0029513$$'         | 'Store 02' | 'Scarf + Dress/Dress+Trousers' |
		| '14,000'   | '$$ShipmentConfirmation0029513$$' | 'Store 02' | 'XS/Blue'                             |
		| '14,000'   | '$$ShipmentConfirmation0029513$$' | 'Store 02' | '36/Yellow'                           |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                | 'Store'    | 'Item key'                            |
		| '7,000'    | '$$GoodsReceipt0029513$$' | 'Store 02' | 'Scarf + Dress/Dress+Trousers' |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                | 'Receipt basis'       | 'Store'    | 'Item key'                            |
		| '7,000'    | '$$GoodsReceipt0029513$$' | '$$Bundling0029507$$' | 'Store 02' | 'Scarf + Dress/Dress+Trousers' |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                        | 'Shipment basis'      | 'Store'    | 'Item key'  |
		| '14,000'   | '$$ShipmentConfirmation0029513$$' | '$$Bundling0029507$$' | 'Store 02' | 'XS/Blue'   |
		| '14,000'   | '$$ShipmentConfirmation0029513$$' | '$$Bundling0029507$$' | 'Store 02' | '36/Yellow' |
	And I close all client application windows

Scenario: _029515 check automatic creation of ItemKey by bundles
	Given I open hyperlink "e1cib/list/Catalog.Items"
	And I go to line in "List" table
		| 'Description'       | 'Item type' |
		| 'Scarf + Dress' | 'Clothes'   |
	And I select current line in "List" table
	And In this window I click command interface button "Item keys"
	And "List" table contains lines
		| Item key                      |
		| Scarf + Dress/Dress+Scarf |
		| Scarf + Dress/Dress+Trousers |
	And I close all client application windows


Scenario: _029516 checking duplicate specifications when creating the same bundle
	* Create Bundle
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Scarf + Dress' |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Scarf'       |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"
		And Delay 5
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And "List" table contains lines
			| 'Description'    | 'Type'   | 'Reference'      |
			| 'A-8'            | 'Set'    | 'A-8'            |
			| 'S-8'            | 'Set'    | 'S-8'            |
			| 'Dress+Shirt'    | 'Bundle' | 'Dress+Shirt'    |
			| 'Dress+Trousers' | 'Bundle' | 'Dress+Trousers' |
			| 'Trousers'       | 'Set'    | 'Trousers'       |
			| 'Dress'          | 'Set'    | 'Dress'          |
			| 'Test'           | 'Bundle' | 'Test'           |
			| 'Chewing gum'    | 'Set'    | 'Chewing gum'    |
			| 'Dress+Scarf'    | 'Bundle' | 'Dress+Scarf'    |
			| 'Dress+Trousers' | 'Bundle' | 'Dress+Trousers' |
		Then the number of "List" table lines is "меньше или равно" 10


Scenario: _029518 creating a bundle of 2 different properties + one repeating of the same item + 1 other item
	* Create bundle
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description' |
			| 'Scarf + Dress'   |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| Description |
			| pcs         |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item  | Item key  |
			| Dress | XS/Blue |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item  | Item key  |
			| Dress | XS/Blue |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item  | Item key  |
			| Dress | L/Green |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Scarf    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item  | Item key  |
			| Scarf | XS/Red |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberBundling0029518$$"
		And I save the window as "$$Bundling0029518$$"
		And I click the button named "FormPostAndClose"
		And Delay 10
	* Check creation of an Item key on a bundle by Dress + Scarf
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| Description         | Item type |
			| Scarf + Dress   | Clothes   |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And "List" table contains lines
			| 'Item key'                    |
			| 'Scarf + Dress/Dress+Scarf' |
			| 'Scarf + Dress/Dress+Scarf' |
		And I close all client application windows
	* Check an auto-generated specification on Bundle
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Description_en" became equal to "Dress+Scarf"
		Then the form attribute named "Type" became equal to "Bundle"
		And "FormTable*" table contains lines
			| 'Size' | 'Color' | 'Quantity' |
			| 'XS'   | 'Blue'  | '2,000'    |
			| 'XS'   | 'Blue'  | '2,000'    |
			| 'L'    | 'Green' | '2,000'    |
		And I close all client application windows
	* Check movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key'                      |
			| '2,000'    | '$$Bundling0029518$$' | 'Store 01' | 'Scarf + Dress/Dress+Scarf' |
			| '4,000'    | '$$Bundling0029518$$' | 'Store 01' | 'XS/Blue'                       |
			| '4,000'    | '$$Bundling0029518$$' | 'Store 01' | 'XS/Blue'                       |
			| '4,000'    | '$$Bundling0029518$$' | 'Store 01' | 'L/Green'                       |
			| '4,000'    | '$$Bundling0029518$$' | 'Store 01' | 'XS/Red'                        |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key'                      |
			| '2,000'    | '$$Bundling0029518$$' | 'Store 01' | 'Scarf + Dress/Dress+Scarf' |
			| '8,000'    | '$$Bundling0029518$$' | 'Store 01' | 'XS/Blue'                       |
			| '4,000'    | '$$Bundling0029518$$' | 'Store 01' | 'L/Green'                       |
			| '4,000'    | '$$Bundling0029518$$' | 'Store 01' | 'XS/Red'                        |
		And I close all client application windows

Scenario: _029519 create Bundling (Store use Goods receipt, doesn't use Shipment confirmation)
	* Opening form for creating Bundle
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Skittles + Chewing gum' |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 07'  |
		And I select current line in "List" table
	* Filling in items table
		And I input "7,000" text in the field named "Quantity"
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Skittles' |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Chewing gum'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| 'Mint/Mango' |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post document and check movements
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberBundling0029519$$"
		And I save the window as "$$Bundling0029519$$"
		And I click the button named "FormPost"
		And Delay 5
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines by template:
		| '$$Bundling0029519$$'                   | ''            | ''          | ''                                            | ''           | ''                    | ''                                            | ''        |
		| 'Document registrations records'        | ''            | ''          | ''                                            | ''           | ''                    | ''                                            | ''        |
		| 'Register  "Bundles content"'           | ''            | ''          | ''                                            | ''           | ''                    | ''                                            | ''        |
		| ''                                      | 'Period'      | 'Resources' | 'Dimensions'                                  | ''           | ''                    | ''                                            | ''        |
		| ''                                      | ''            | 'Quantity'  | 'Item key bundle'                             | 'Item key'   | ''                    | ''                                            | ''        |
		| ''                                      | '*'           | '2'         | 'Skittles + Chewing gum/Skittles+Chewing gum' | 'Mint/Mango' | ''                    | ''                                            | ''        |
		| ''                                      | '*'           | '2'         | 'Skittles + Chewing gum/Skittles+Chewing gum' | 'Fruit'      | ''                    | ''                                            | ''        |
		| ''                                      | ''            | ''          | ''                                            | ''           | ''                    | ''                                            | ''        |
		| 'Register  "Goods in transit incoming"' | ''            | ''          | ''                                            | ''           | ''                    | ''                                            | ''        |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'                                   | 'Dimensions' | ''                    | ''                                            | ''        |
		| ''                                      | ''            | ''          | 'Quantity'                                    | 'Store'      | 'Receipt basis'       | 'Item key'                                    | 'Row key' |
		| ''                                      | 'Receipt'     | '*'         | '7'                                           | 'Store 07'   | '$$Bundling0029519$$' | 'Skittles + Chewing gum/Skittles+Chewing gum' | '*'       |
		| ''                                      | ''            | ''          | ''                                            | ''           | ''                    | ''                                            | ''        |
		| 'Register  "Stock reservation"'         | ''            | ''          | ''                                            | ''           | ''                    | ''                                            | ''        |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'                                   | 'Dimensions' | ''                    | ''                                            | ''        |
		| ''                                      | ''            | ''          | 'Quantity'                                    | 'Store'      | 'Item key'            | ''                                            | ''        |
		| ''                                      | 'Expense'     | '*'         | '14'                                          | 'Store 07'   | 'Mint/Mango'          | ''                                            | ''        |
		| ''                                      | 'Expense'     | '*'         | '14'                                          | 'Store 07'   | 'Fruit'               | ''                                            | ''        |
		| ''                                      | ''            | ''          | ''                                            | ''           | ''                    | ''                                            | ''        |
		| 'Register  "Stock balance"'             | ''            | ''          | ''                                            | ''           | ''                    | ''                                            | ''        |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'                                   | 'Dimensions' | ''                    | ''                                            | ''        |
		| ''                                      | ''            | ''          | 'Quantity'                                    | 'Store'      | 'Item key'            | ''                                            | ''        |
		| ''                                      | 'Expense'     | '*'         | '14'                                          | 'Store 07'   | 'Mint/Mango'          | ''                                            | ''        |
		| ''                                      | 'Expense'     | '*'         | '14'                                          | 'Store 07'   | 'Fruit'               | ''                                            | ''        |
		And I close all client application windows

Scenario: _029520 create Bundling (Store use Shipment confirmation, doesn't use Goods receipt)
	* Opening form for creating Bundle
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Skittles + Chewing gum' |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 08'  |
		And I select current line in "List" table
	* Filling in items table
		And I input "7,000" text in the field named "Quantity"
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Skittles'  |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Skittles' | 'Fruit'  |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Chewing gum'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| 'Mint/Mango' |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post document and check movements
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberBundling0029520$$"
		And I save the window as "$$Bundling0029520$$"
		And I click the button named "FormPost"
		And Delay 5
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$Bundling0029520$$'                   | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Document registrations records'        | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Register  "Bundles content"'           | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| ''                                      | 'Period'      | 'Resources' | 'Dimensions'                          | ''           | ''                                    | ''          | ''        |
			| ''                                      | ''            | 'Quantity'  | 'Item key bundle'                     | 'Item key'   | ''                                    | ''          | ''        |
			| ''                                      | '*'           | '2'         | 'Skittles + Chewing gum/Skittles+Chewing gum' | 'Mint/Mango'    | ''                                    | ''          | ''        |
			| ''                                      | '*'           | '2'         | 'Skittles + Chewing gum/Skittles+Chewing gum' | 'Fruit'  | ''                                    | ''          | ''        |
			| ''                                      | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Register  "Goods in transit outgoing"' | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''                                    | ''          | ''        |
			| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Shipment basis'                      | 'Item key'  | 'Row key' |
			| ''                                      | 'Receipt'     | '*'         | '14'                                  | 'Store 08'   | '$$Bundling0029520$$'                 | 'Mint/Mango'   | '*'       |
			| ''                                      | 'Receipt'     | '*'         | '14'                                  | 'Store 08'   | '$$Bundling0029520$$'                 | 'Fruit' | '*'       |
			| ''                                      | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Register  "Stock reservation"'         | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''                                    | ''          | ''        |
			| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Item key'                            | ''          | ''        |
			| ''                                      | 'Receipt'     | '*'         | '7'                                   | 'Store 08'   | 'Skittles + Chewing gum/Skittles+Chewing gum' | ''          | ''        |
			| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 08'   | 'Mint/Mango'                             | ''          | ''        |
			| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 08'   | 'Fruit'                           | ''          | ''        |
			| ''                                      | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Register  "Stock balance"'             | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''                                    | ''          | ''        |
			| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Item key'                            | ''          | ''        |
			| ''                                      | 'Receipt'     | '*'         | '7'                                   | 'Store 08'   | 'Skittles + Chewing gum/Skittles+Chewing gum' | ''          | ''        |
		And I close all client application windows




Scenario: _029521 check the output of the document movement report for Bundling
	Given I open hyperlink "e1cib/list/Document.Bundling"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberBundling0029501$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines by template:
		| '$$Bundling0029501$$'            | ''            | ''          | ''                          | ''           | ''                          |
		| 'Document registrations records' | ''            | ''          | ''                          | ''           | ''                          |
		| 'Register  "Bundles content"'    | ''            | ''          | ''                          | ''           | ''                          |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'                | ''           | ''                          |
		| ''                               | ''            | 'Quantity'  | 'Item key bundle'           | 'Item key'   | ''                          |
		| ''                               | '*'           | '1'         | 'Scarf + Dress/Dress+Scarf' | 'XS/Blue'    | ''                          |
		| ''                               | '*'           | '1'         | 'Scarf + Dress/Dress+Scarf' | 'XS/Red'     | ''                          |
		| ''                               | ''            | ''          | ''                          | ''           | ''                          |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''                          | ''           | ''                          |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                 | 'Dimensions' | ''                          |
		| ''                               | ''            | ''          | 'Quantity'                  | 'Store'      | 'Item key'                  |
		| ''                               | 'Receipt'     | '*'         | '10'                        | 'Store 01'   | 'Scarf + Dress/Dress+Scarf' |
		| ''                               | 'Expense'     | '*'         | '10'                        | 'Store 01'   | 'XS/Blue'                   |
		| ''                               | 'Expense'     | '*'         | '10'                        | 'Store 01'   | 'XS/Red'                    |
		| ''                               | ''            | ''          | ''                          | ''           | ''                          |
		| 'Register  "Stock balance"'      | ''            | ''          | ''                          | ''           | ''                          |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                 | 'Dimensions' | ''                          |
		| ''                               | ''            | ''          | 'Quantity'                  | 'Store'      | 'Item key'                  |
		| ''                               | 'Receipt'     | '*'         | '10'                        | 'Store 01'   | 'Scarf + Dress/Dress+Scarf' |
		| ''                               | 'Expense'     | '*'         | '10'                        | 'Store 01'   | 'XS/Blue'                   |
		| ''                               | 'Expense'     | '*'         | '10'                        | 'Store 01'   | 'XS/Red'                    |

	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Bundling"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberBundling0029501$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$Bundling0029501$$'            | ''            | ''          | ''                          | ''           | ''                          |
		| 'Document registrations records' | ''            | ''          | ''                          | ''           | ''                          |
		| 'Register  "Bundles content"'    | ''            | ''          | ''                          | ''           | ''                          |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'                | ''           | ''                          |
		| ''                               | ''            | 'Quantity'  | 'Item key bundle'           | 'Item key'   | ''                          |
		| ''                               | '*'           | '1'         | 'Scarf + Dress/Dress+Scarf' | 'XS/Blue'    | ''                          |
		| ''                               | '*'           | '1'         | 'Scarf + Dress/Dress+Scarf' | 'XS/Red'     | ''                          |
		| ''                               | ''            | ''          | ''                          | ''           | ''                          |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''                          | ''           | ''                          |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                 | 'Dimensions' | ''                          |
		| ''                               | ''            | ''          | 'Quantity'                  | 'Store'      | 'Item key'                  |
		| ''                               | 'Receipt'     | '*'         | '10'                        | 'Store 01'   | 'Scarf + Dress/Dress+Scarf' |
		| ''                               | 'Expense'     | '*'         | '10'                        | 'Store 01'   | 'XS/Blue'                   |
		| ''                               | 'Expense'     | '*'         | '10'                        | 'Store 01'   | 'XS/Red'                    |
		| ''                               | ''            | ''          | ''                          | ''           | ''                          |
		| 'Register  "Stock balance"'      | ''            | ''          | ''                          | ''           | ''                          |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                 | 'Dimensions' | ''                          |
		| ''                               | ''            | ''          | 'Quantity'                  | 'Store'      | 'Item key'                  |
		| ''                               | 'Receipt'     | '*'         | '10'                        | 'Store 01'   | 'Scarf + Dress/Dress+Scarf' |
		| ''                               | 'Expense'     | '*'         | '10'                        | 'Store 01'   | 'XS/Blue'                   |
		| ''                               | 'Expense'     | '*'         | '10'                        | 'Store 01'   | 'XS/Red'                    |

	And I close all client application windows


Scenario: _02951901 clear movements Bundling and check that there is no movements on the registers 
	* Open list form Bundling
		Given I open hyperlink "e1cib/list/Document.Bundling"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBundling0029501$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Bundles content"'    |
			| 'Register  "Stock reservation"'  |
			| 'Register  "Stock balance"'      |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBundling0029501$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document contains lines:
		| '$$Bundling0029501$$'            | ''            | ''          | ''                          | ''           | ''                          |
		| 'Document registrations records' | ''            | ''          | ''                          | ''           | ''                          |
		| 'Register  "Bundles content"'    | ''            | ''          | ''                          | ''           | ''                          |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'                | ''           | ''                          |
		| ''                               | ''            | 'Quantity'  | 'Item key bundle'           | 'Item key'   | ''                          |
		| ''                               | '*'           | '1'         | 'Scarf + Dress/Dress+Scarf' | 'XS/Blue'    | ''                          |
		| ''                               | '*'           | '1'         | 'Scarf + Dress/Dress+Scarf' | 'XS/Red'     | ''                          |
		| ''                               | ''            | ''          | ''                          | ''           | ''                          |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''                          | ''           | ''                          |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                 | 'Dimensions' | ''                          |
		| ''                               | ''            | ''          | 'Quantity'                  | 'Store'      | 'Item key'                  |
		| ''                               | 'Receipt'     | '*'         | '10'                        | 'Store 01'   | 'Scarf + Dress/Dress+Scarf' |
		| ''                               | 'Expense'     | '*'         | '10'                        | 'Store 01'   | 'XS/Blue'                   |
		| ''                               | 'Expense'     | '*'         | '10'                        | 'Store 01'   | 'XS/Red'                    |
		| ''                               | ''            | ''          | ''                          | ''           | ''                          |
		| 'Register  "Stock balance"'      | ''            | ''          | ''                          | ''           | ''                          |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                 | 'Dimensions' | ''                          |
		| ''                               | ''            | ''          | 'Quantity'                  | 'Store'      | 'Item key'                  |
		| ''                               | 'Receipt'     | '*'         | '10'                        | 'Store 01'   | 'Scarf + Dress/Dress+Scarf' |
		| ''                               | 'Expense'     | '*'         | '10'                        | 'Store 01'   | 'XS/Blue'                   |
		| ''                               | 'Expense'     | '*'         | '10'                        | 'Store 01'   | 'XS/Red'                    |
		And I close all client application windows


Scenario: _300519 check connection to Bundling report "Related documents"
	Given I open hyperlink "e1cib/list/Document.Bundling"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberBundling0029501$$     |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows