#language: en
@tree
@Positive
@Group7

Feature: Bundling

As a sales manager
I want to create Bundle
For joint sale of products


Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _029500 preparation (Bundling)
	
	* Create store that use Goods receipt and doesn't use Shipment confirmation
		Given I open hyperlink "e1cib/list/Catalog.Stores"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Store 07" text in the field named "Description_en"
		And I input "Store 07 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "UseGoodsReceipt"
		And I remove checkbox named "UseShipmentConfirmation"
		And I click the button named "FormWriteAndClose"
		And Delay 2
	* Create store that use Shipment confirmation and doesn't use Goods receipt
		Given I open hyperlink "e1cib/list/Catalog.Stores"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Store 08" text in the field named "Description_en"
		And I input "Store 08 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I remove checkbox named "UseGoodsReceipt"
		And I set checkbox named "UseShipmentConfirmation"
		And I click the button named "FormWriteAndClose"
		And Delay 2
		And I close all client application windows


Scenario: _029501 create Bundling (Store doesn't use Shipment confirmation and Goods receipt)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Bundling"
	And I click the button named "FormCreate"
	// * Change number
	// 	And I input "1" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "1" text in "Number" field
	And I click Select button of "Company" field
	And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
	And I select current line in "List" table
	And I click Select button of "Item bundle" field
	And I go to line in "List" table
		| 'Description'       |
		| 'Bound Dress+Shirt' |
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
		| 'Shirt'       |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I select current line in "List" table
	And I activate field named "ItemListQuantity" in "ItemList" table
	And I input "1,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberBundling0029501$$"
	And I save the window as "$$Bundling0029501$$"
	And I click "Post and close" button
	And Delay 5

Scenario: _029502 check the automatic creation of the Bundle specification
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.Specifications"
	And I go to line in "List" table
		| 'Description' | 'Type'   |
		| 'Dress+Shirt' | 'Bundle' |
	And I select current line in "List" table
	Then the form attribute named "Type" became equal to "Bundle"
	Then the form attribute named "ItemBundle" became equal to "Bound Dress+Shirt"
	And "FormTable*" table contains lines
		| 'Size' | 'Color' | 'Quantity' |
		| 'XS'   | 'Blue'  | '1*'    |
	And I close current window

Scenario: _029503 check Bundling posting (store doesn't use Shipment confirmation and Goods receipt) by register StockBalance
# In this case a Bandle is received by register and the goods from the Bandle are written off
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key'                      |
	| '10,000'   | '$$Bundling0029501$$' | 'Store 01' | 'Bound Dress+Shirt/Dress+Shirt' |
	| '10,000'   | '$$Bundling0029501$$' | 'Store 01' | 'XS/Blue'                       |
	| '10,000'   | '$$Bundling0029501$$' | 'Store 01' | '36/Red'                        |
	And I close all client application windows

Scenario: _029504 check Bundling posting (store doesn't use Shipment confirmation and Goods receipt) by register StockReservation
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key'                      |
	| '10,000'   | '$$Bundling0029501$$' | 'Store 01' | 'Bound Dress+Shirt/Dress+Shirt' |
	| '10,000'   | '$$Bundling0029501$$' | 'Store 01' | 'XS/Blue'                       |
	| '10,000'   | '$$Bundling0029501$$' | 'Store 01' | '36/Red'                        |
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
	// * Change number
	// 		And I input "2" text in "Number" field
	// 		Then "1C:Enterprise" window is opened
	// 		And I click "Yes" button
	// 		And I input "2" text in "Number" field
	And I click Select button of "Company" field
	And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
	And I select current line in "List" table
	And I click Select button of "Item bundle" field
	And I go to line in "List" table
		| 'Description'       |
		| 'Bound Dress+Trousers' |
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
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberBundling0029507$$"
	And I save the window as "$$Bundling0029507$$"
	And I click "Post and close" button
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
	| '7,000'    | '$$Bundling0029507$$' | 'Store 02' | 'Bound Dress+Trousers' |
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
	| '7,000'    | '$$Bundling0029507$$' | 'Store 02' | 'Bound Dress+Trousers' |
	And I close all client application windows

Scenario: _029511 check Bundling posting (store use Shipment confirmation and Goods receipt) by register GoodsInTransitIncoming
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'            | 'Receipt basis'       | 'Store'    | 'Item key'                            |
		| '7,000'    | '$$Bundling0029507$$' | '$$Bundling0029507$$' | 'Store 02' | 'Bound Dress+Trousers/Dress+Trousers' |
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
		| 'Bound Dress+Trousers' | '$$NumberBundling0029507$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
	Then the form attribute named "Company" became equal to "Main Company"
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberGoodsReceipt0029513$$"
	And I save the window as "$$GoodsReceipt0029513$$"
	And I click "Post and close" button
	And Delay 5
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	Then the form attribute named "Company" became equal to "Main Company"
	// And I input "151" text in "Number" field
	// Then "1C:Enterprise" window is opened
	// And I click "Yes" button
	// And I input "151" text in "Number" field
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberShipmentConfirmation0029513$$"
	And I save the window as "$$ShipmentConfirmation0029513$$"
	And I click "Post and close" button
	And Delay 5
	And I close current window

Scenario: _029514 check Shipment confirmation and Goods receipt movements based on document Bundling
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                        | 'Store'    | 'Item key'                            |
		| '7,000'    | '$$GoodsReceipt0029513$$'         | 'Store 02' | 'Bound Dress+Trousers/Dress+Trousers' |
		| '14,000'   | '$$ShipmentConfirmation0029513$$' | 'Store 02' | 'XS/Blue'                             |
		| '14,000'   | '$$ShipmentConfirmation0029513$$' | 'Store 02' | '36/Yellow'                           |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                | 'Store'    | 'Item key'                            |
		| '7,000'    | '$$GoodsReceipt0029513$$' | 'Store 02' | 'Bound Dress+Trousers/Dress+Trousers' |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                | 'Receipt basis'       | 'Store'    | 'Item key'                            |
		| '7,000'    | '$$GoodsReceipt0029513$$' | '$$Bundling0029507$$' | 'Store 02' | 'Bound Dress+Trousers/Dress+Trousers' |
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
		| Description       | Item type |
		| Bound Dress+Shirt | Clothes   |
	And I select current line in "List" table
	And In this window I click command interface button "Item keys"
	And I go to line in "List" table
		| Item key                      |
		| Bound Dress+Shirt/Dress+Shirt |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.Items"
	And I go to line in "List" table
		| Description          | Item type |
		| Bound Dress+Trousers | Clothes   |
	And I select current line in "List" table
	And In this window I click command interface button "Item keys"
	And I go to line in "List" table
		| Item key                            |
		| Bound Dress+Trousers/Dress+Trousers |
	And I close all client application windows

Scenario: _029516 hecking duplicate specifications when creating the same bundle
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
			| 'Bound Dress+Shirt' |
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
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		And Delay 5
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And "List" table became equal
			| 'Description'    | 'Type'   |
			| 'A-8'            | 'Set'    |
			| 'S-8'            | 'Set'    |
			| 'Dress+Shirt'    | 'Bundle' |
			| 'Dress+Trousers' | 'Bundle' |

Scenario: _029517 check the creation of a specification when forming a bundle for the same item
	* Create Bundle
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
		// * Change number
		// 	And I input "4" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "4" text in "Number" field
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| Description |
			| Trousers    |
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
		And I input "10,000" text in the field named "Quantity"
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Trousers    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item     | Item key  |
			| Trousers | 38/Yellow |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Trousers    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberBundling0029517$$"
		And I save the window as "$$Bundling0029517$$"
		And I click "Post and close" button
		And Delay 10
	* Check item key creation for bundle by Trousers
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| Description    | Item type |
			| Trousers       | Clothes   |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I go to line in "List" table
			| Item key          |
			| Trousers/Trousers |
		And I close all client application windows
	* Check an auto-generated specification on Set
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I go to line in "List" table
			| 'Description' | 'Type'   |
			| 'Trousers' | 'Set' |
		And I select current line in "List" table
		Then the form attribute named "Description_en" became equal to "Trousers"
		Then the form attribute named "Type" became equal to "Set"
		And "FormTable*" table contains lines
			| 'Size' | 'Color'  | 'Quantity' |
			| '36'   | 'Yellow' | '2,000'    |
			| '38'   | 'Yellow' | '2,000'    |
		Then the form attribute named "ItemField*" became equal to "Clothes"
		And I close all client application windows
	* Check movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key'          |
			| '10,000'   | '$$Bundling0029517$$' | 'Store 01' | 'Trousers/Trousers' |
			| '20,000'   | '$$Bundling0029517$$' | 'Store 01' | '36/Yellow'         |
			| '20,000'   | '$$Bundling0029517$$' | 'Store 01' | '38/Yellow'         |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key'          |
			| '10,000'   | '$$Bundling0029517$$' | 'Store 01' | 'Trousers/Trousers' |
			| '20,000'   | '$$Bundling0029517$$' | 'Store 01' | '36/Yellow'         |
			| '20,000'   | '$$Bundling0029517$$' | 'Store 01' | '38/Yellow'         |
		And I close all client application windows

Scenario: _029518 creating a bundle of 2 different properties + one repeating of the same item + 1 other item
	* Create bundle
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
		// * Change number
		// 	And I input "5" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "5" text in "Number" field
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| Description |
			| Bound Dress+Shirt    |
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
			| Shirt    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item  | Item key  |
			| Shirt | 36/Red |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberBundling0029518$$"
		And I save the window as "$$Bundling0029518$$"
		And I click "Post and close" button
		And Delay 10
	* Check creation of an Item key on a bundle by Dress + Shirt
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| Description         | Item type |
			| Bound Dress+Shirt   | Clothes   |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And "List" table contains lines
			| Item key                      |
			| Bound Dress+Shirt/Dress+Shirt |
			| Bound Dress+Shirt/Dress+Shirt |
		And I close all client application windows
	* Check an auto-generated specification on Bundle
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Description_en" became equal to "Dress+Shirt"
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
			| '2,000'    | '$$Bundling0029518$$' | 'Store 01' | 'Bound Dress+Shirt/Dress+Shirt' |
			| '4,000'    | '$$Bundling0029518$$' | 'Store 01' | 'XS/Blue'                       |
			| '4,000'    | '$$Bundling0029518$$' | 'Store 01' | 'XS/Blue'                       |
			| '4,000'    | '$$Bundling0029518$$' | 'Store 01' | 'L/Green'                       |
			| '4,000'    | '$$Bundling0029518$$' | 'Store 01' | '36/Red'                        |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Item key'                      |
			| '2,000'    | '$$Bundling0029518$$' | 'Store 01' | 'Bound Dress+Shirt/Dress+Shirt' |
			| '8,000'    | '$$Bundling0029518$$' | 'Store 01' | 'XS/Blue'                       |
			| '4,000'    | '$$Bundling0029518$$' | 'Store 01' | 'L/Green'                       |
			| '4,000'    | '$$Bundling0029518$$' | 'Store 01' | '36/Red'                        |
		And I close all client application windows

Scenario: _029519 create Bundling (Store use Goods receipt, doesn't use Shipment confirmation)
	* Opening form for creating Bundle
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
	// * Change number
	// 		And I input "7" text in "Number" field
	// 		Then "1C:Enterprise" window is opened
	// 		And I click "Yes" button
	// 		And I input "7" text in "Number" field
	* Filling in details
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Bound Dress+Trousers' |
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
	* Post document and check movements
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberBundling0029519$$"
		And I save the window as "$$Bundling0029519$$"
		And I click "Post" button
		And Delay 5
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| '$$Bundling0029519$$'                   | ''            | ''          | ''                                    | ''           | ''                    | ''                                    | ''        |
		| 'Document registrations records'        | ''            | ''          | ''                                    | ''           | ''                    | ''                                    | ''        |
		| 'Register  "Bundles content"'           | ''            | ''          | ''                                    | ''           | ''                    | ''                                    | ''        |
		| ''                                      | 'Period'      | 'Resources' | 'Dimensions'                          | ''           | ''                    | ''                                    | ''        |
		| ''                                      | ''            | 'Quantity'  | 'Item key bundle'                     | 'Item key'   | ''                    | ''                                    | ''        |
		| ''                                      | '*'           | '2'         | 'Bound Dress+Trousers/Dress+Trousers' | 'XS/Blue'    | ''                    | ''                                    | ''        |
		| ''                                      | '*'           | '2'         | 'Bound Dress+Trousers/Dress+Trousers' | '36/Yellow'  | ''                    | ''                                    | ''        |
		| ''                                      | ''            | ''          | ''                                    | ''           | ''                    | ''                                    | ''        |
		| 'Register  "Goods in transit incoming"' | ''            | ''          | ''                                    | ''           | ''                    | ''                                    | ''        |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''                    | ''                                    | ''        |
		| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Receipt basis'       | 'Item key'                            | 'Row key' |
		| ''                                      | 'Receipt'     | '*'         | '7'                                   | 'Store 07'   | '$$Bundling0029518$$' | 'Bound Dress+Trousers/Dress+Trousers' | '*'       |
		| ''                                      | ''            | ''          | ''                                    | ''           | ''                    | ''                                    | ''        |
		| 'Register  "Stock reservation"'         | ''            | ''          | ''                                    | ''           | ''                    | ''                                    | ''        |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''                    | ''                                    | ''        |
		| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Item key'            | ''                                    | ''        |
		| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 07'   | 'XS/Blue'             | ''                                    | ''        |
		| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 07'   | '36/Yellow'           | ''                                    | ''        |
		| ''                                      | ''            | ''          | ''                                    | ''           | ''                    | ''                                    | ''        |
		| 'Register  "Stock balance"'             | ''            | ''          | ''                                    | ''           | ''                    | ''                                    | ''        |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''                    | ''                                    | ''        |
		| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Item key'            | ''                                    | ''        |
		| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 07'   | 'XS/Blue'             | ''                                    | ''        |
		| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 07'   | '36/Yellow'           | ''                                    | ''        |
		And I close all client application windows

Scenario: _029520 create Bundling (Store use Shipment confirmation, doesn't use Goods receipt)
	* Opening form for creating Bundle
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
	// * Change number
	// 	And I input "8" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "8" text in "Number" field
	* Filling in details
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Bound Dress+Trousers' |
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
	* Post document and check movements
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberBundling0029520$$"
		And I save the window as "$$Bundling0029520$$"
		And I click "Post" button
		And Delay 5
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
			| '$$Bundling0029520$$'                   | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Document registrations records'        | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Register  "Bundles content"'           | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| ''                                      | 'Period'      | 'Resources' | 'Dimensions'                          | ''           | ''                                    | ''          | ''        |
			| ''                                      | ''            | 'Quantity'  | 'Item key bundle'                     | 'Item key'   | ''                                    | ''          | ''        |
			| ''                                      | '*'           | '2'         | 'Bound Dress+Trousers/Dress+Trousers' | 'XS/Blue'    | ''                                    | ''          | ''        |
			| ''                                      | '*'           | '2'         | 'Bound Dress+Trousers/Dress+Trousers' | '36/Yellow'  | ''                                    | ''          | ''        |
			| ''                                      | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Register  "Goods in transit outgoing"' | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''                                    | ''          | ''        |
			| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Shipment basis'                      | 'Item key'  | 'Row key' |
			| ''                                      | 'Receipt'     | '*'         | '14'                                  | 'Store 08'   | '$$Bundling0029520$$'                 | 'XS/Blue'   | '*'       |
			| ''                                      | 'Receipt'     | '*'         | '14'                                  | 'Store 08'   | '$$Bundling0029520$$'                 | '36/Yellow' | '*'       |
			| ''                                      | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Register  "Stock reservation"'         | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''                                    | ''          | ''        |
			| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Item key'                            | ''          | ''        |
			| ''                                      | 'Receipt'     | '*'         | '7'                                   | 'Store 08'   | 'Bound Dress+Trousers/Dress+Trousers' | ''          | ''        |
			| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 08'   | 'XS/Blue'                             | ''          | ''        |
			| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 08'   | '36/Yellow'                           | ''          | ''        |
			| ''                                      | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Register  "Stock balance"'             | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''                                    | ''          | ''        |
			| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Item key'                            | ''          | ''        |
			| ''                                      | 'Receipt'     | '*'         | '7'                                   | 'Store 08'   | 'Bound Dress+Trousers/Dress+Trousers' | ''          | ''        |
		And I close all client application windows

