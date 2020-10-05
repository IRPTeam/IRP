#language: en
@tree
@Positive
@Inventory

Feature: Unbundling

As a sales manager
I want to create Unbundling
For sale of products from a Bundle separately

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _029600 preparation (Unbundling)
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
		When Create catalog PriceTypes objects
		When Create catalog Currencies objects
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
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company

Scenario: _029601 create Unbundling on a product with a specification (specification created in advance, Store doesn't use Shipment confirmation and Goods receipt)
# the fill button on the specification. The specification specifies all additional properties
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	* Create Unbundling for Dress/A-8, all item keys were created in advance
		And I click the button named "FormCreate"
		// * Change number
		// 	And I input "1" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "1" text in "Number" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I click Select button of "Item key bundle" field
		And I go to line in "List" table
			| Item  | Item key  |
			| Dress | Dress/A-8 |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| Description |
			| pcs      |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 01  |
		And I select current line in "List" table
		And I move to "Item list" tab
		And in the table "ItemList" I click "By specification" button
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberUnbundling0029601$$"
		And I save the window as "$$Unbundling0029601$$"
		And I click "Post and close" button
	* Check the creation of Unbundling
		And "List" table contains lines
			| Item key bundle | Company      |
			| Dress/A-8       | Main Company |
	And I close all client application windows
	
Scenario: _029602 check Bundling posting (store doesn't use Shipment confirmation and Goods receipt) by register Stock Balance
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                   | 'Store'    | 'Item key'                            |
		| '2,000'    | '$$Unbundling0029601$$'              | 'Store 01' | 'S/Yellow'                            |
		| '2,000'    | '$$Unbundling0029601$$'              | 'Store 01' | 'XS/Blue'                             |
		| '4,000'    | '$$Unbundling0029601$$'              | 'Store 01' | 'L/Green'                             |
		| '4,000'    | '$$Unbundling0029601$$'              | 'Store 01' | 'M/Brown'                             |
		| '2,000'    | '$$Unbundling0029601$$'              | 'Store 01' | 'Dress/A-8'                           |
	And I close all client application windows

Scenario: _029603 check Bundling posting (store doesn't use Shipment confirmation and Goods receipt) by register Stock Reservation
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Store'     | 'Item key'                                                            |
		| '2,000'    | '$$Unbundling0029601$$'               | 'Store 01'  | 'S/Yellow'                                                            |
		| '2,000'    | '$$Unbundling0029601$$'               | 'Store 01'  | 'XS/Blue'                                                             |
		| '4,000'    | '$$Unbundling0029601$$'               | 'Store 01'  | 'L/Green'                                                             |
		| '4,000'    | '$$Unbundling0029601$$'               | 'Store 01'  | 'M/Brown'                                                             |
		| '2,000'    | '$$Unbundling0029601$$'               | 'Store 01'  | 'Dress/A-8'                                                           |
	And I close all client application windows

Scenario: _029604 create Unbundling on a product with a specification (specification created in advance, Store use Shipment confirmation and Goods receipt)
	When create a purchase invoice for the purchase of sets and dimensional grids at the tore 02
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	* Create Unbundling for Boots/S-8, all item keys were created in advance
		And I click the button named "FormCreate"
		// * Change number
		// 	And I input "2" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "2" text in "Number" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| Description |
			| Boots       |
		And I select current line in "List" table
		And I click Select button of "Item key bundle" field
		And I go to line in "List" table
			| Item  | Item key  |
			| Boots | Boots/S-8 |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| Description |
			| pcs      |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 02  |
		And I select current line in "List" table
		And I move to "Item list" tab
		And in the table "ItemList" I click "By specification" button
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberUnbundling0029604$$"
		And I save the window as "$$Unbundling0029604$$"
		And I click "Post and close" button
	* Check the creation of Unbundling
		And "List" table contains lines
			| Item key bundle | Company      |
			| Boots/S-8       | Main Company |
	And I close all client application windows

Scenario: _029605 check the absence posting of Unbundling (store use Shipment confirmation and Goods receipt) by register Stock Balance
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
		| 'Recorder'                   |
		| '$$Unbundling0029604$$'              |
	And I close all client application windows

Scenario: _029606 check Bundling posting (store use Shipment confirmation and Goods receipt) by register Stock Reservation
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key'  |
		| '2,000'    | '$$Unbundling0029604$$' | 'Store 02' | 'Boots/S-8' |
	And I close all client application windows

Scenario: _029607 check Bundling posting (store use Shipment confirmation and Goods receipt) by register GoodsInTransitOutgoing
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Shipment basis'        | 'Store'    | 'Item key'  |
		| '2,000'    | '$$Unbundling0029604$$' | '$$Unbundling0029604$$' | 'Store 02' | 'Boots/S-8' |
	And I close all client application windows

Scenario: _029608 check Bundling posting (store use Shipment confirmation and Goods receipt) by register GoodsInTransitIncoming
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Receipt basis'         | 'Store'    | 'Item key' |
		| '2,000'    | '$$Unbundling0029604$$' | '$$Unbundling0029604$$' | 'Store 02' | '36/18SD'  |
		| '2,000'    | '$$Unbundling0029604$$' | '$$Unbundling0029604$$' | 'Store 02' | '37/18SD'  |
		| '2,000'    | '$$Unbundling0029604$$' | '$$Unbundling0029604$$' | 'Store 02' | '38/18SD'  |
		| '2,000'    | '$$Unbundling0029604$$' | '$$Unbundling0029604$$' | 'Store 02' | '39/18SD'  |
	And I close all client application windows

Scenario: _029609 create Goods receipt and Shipment confirmation based on Unbundling
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	* Create Goods receipt and Shipment confirmation
		And I go to line in "List" table
			| Company      | Item key bundle | Number |
			| Main Company | Boots/S-8       | 2      |
		And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
		Then the form attribute named "Company" became equal to "Main Company"
		// * Change number Shipment confirmation to 152
		// 	And I input "152" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "152" text in "Number" field
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberShipmentConfirmation0029609$$"
		And I save the window as "$$ShipmentConfirmation0029609$$"
		And I click "Post and close" button
		And Delay 5
		And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
		Then the form attribute named "Company" became equal to "Main Company"
		// * Change number Goods receipt to 153
		// 	And I input "153" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "153" text in "Number" field
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberGoodsReceipt0029609$$"
		And I save the window as "$$GoodsReceipt0029609$$"
		And I click "Post and close" button
		And Delay 5
		And I close all client application windows
	* Check movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                | 'Store'    | 'Item key' |
			| '2,000'    | '$$GoodsReceipt0029609$$' | 'Store 02' | '36/18SD'  |
			| '2,000'    | '$$GoodsReceipt0029609$$' | 'Store 02' | '37/18SD'  |
			| '2,000'    | '$$GoodsReceipt0029609$$' | 'Store 02' | '38/18SD'  |
			| '2,000'    | '$$GoodsReceipt0029609$$' | 'Store 02' | '39/18SD'  |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                | 'Store'    | 'Item key' |
			| '2,000'    | '$$GoodsReceipt0029609$$' | 'Store 02' | '36/18SD'  |
			| '2,000'    | '$$GoodsReceipt0029609$$' | 'Store 02' | '37/18SD'  |
			| '2,000'    | '$$GoodsReceipt0029609$$' | 'Store 02' | '38/18SD'  |
			| '2,000'    | '$$GoodsReceipt0029609$$' | 'Store 02' | '39/18SD'  |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                        | 'Shipment basis'        | 'Store'    | 'Item key'  |
			| '2,000'    | '$$ShipmentConfirmation0029609$$' | '$$Unbundling0029604$$' | 'Store 02' | 'Boots/S-8' |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
		And "List" table contains lines
		| 'Quantity' | 'Recorder'                | 'Receipt basis'         | 'Store'    | 'Item key' |
		| '2,000'    | '$$GoodsReceipt0029609$$' | '$$Unbundling0029604$$' | 'Store 02' | '36/18SD'  |
		| '2,000'    | '$$GoodsReceipt0029609$$' | '$$Unbundling0029604$$' | 'Store 02' | '37/18SD'  |
		| '2,000'    | '$$GoodsReceipt0029609$$' | '$$Unbundling0029604$$' | 'Store 02' | '38/18SD'  |
		| '2,000'    | '$$GoodsReceipt0029609$$' | '$$Unbundling0029604$$' | 'Store 02' | '39/18SD'  |
		And I close all client application windows


Scenario: _029610 create Unbundling (+check movements) for bundl which was created independently
# When create a Unbundling based on bundle from a vendor, the missing item key is additionally created. 
# For example, there is a cola+chocolate bandle. When creating Unbundling on this bundle is created to unpack  2 items (Coke and Chocolate) and also item keys 
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	* Create Unbundling for Bundle Dress+Shirt
		And I click the button named "FormCreate"
		// * Change number
		// 	And I input "3" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "3" text in "Number" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description' |
			| 'Skittles + Chewing gum'      |
		And I select current line in "List" table
		And I click Select button of "Item key bundle" field
		And I go to line in "List" table
			| 'Item'                   | 'Item key'                                    |
			| 'Skittles + Chewing gum' | 'Skittles + Chewing gum/Skittles+Chewing gum' |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| Description |
			| pcs      |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 01  |
		And I select current line in "List" table
		And I move to "Item list" tab
		And in the table "ItemList" I click "By specification" button
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberUnbundling0029610$$"
		And I save the window as "$$Unbundling0029610$$"
		And I click "Post and close" button
		* Check the creation of Unbundling
			And "List" table contains lines
				| 'Item key bundle'                             | 'Company'      |
				| 'Skittles + Chewing gum/Skittles+Chewing gum' | 'Main Company' |
		And I close all client application windows

Scenario: _029611 create Unbundling (+check movements) for bundl (there is a Bundling document) for which the specification was changed
# the missing item key on the items is created automatically
	* Change specification Dress+Trousers
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I go to line in "List" table
			| Description    | Type   |
			| Skittles+Chewing gum | Bundle |
		And I select current line in "List" table
		And I activate field named "Quantity*" in "FormTable*" table
		And I input "4,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And I click "Save and close" button
		And Delay 5
	* Create Unbundling for item Dress+Trousers
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I click the button named "FormCreate"
		// * Change number
		// 	And I input "4" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "4" text in "Number" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description' |
			| 'Skittles + Chewing gum'       |
		And I select current line in "List" table
		And I click Select button of "Item key bundle" field
		And I go to line in "List" table
			| 'Item'              | 'Item key'  |
			| 'Skittles + Chewing gum' | 'Skittles + Chewing gum/Skittles+Chewing gum' |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| Description |
			| pcs      |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 01  |
		And I select current line in "List" table
		And I move to "Item list" tab
		And in the table "ItemList" I click "By bundle content" button
		And "ItemList" table contains lines
			| 'Item'        | 'Quantity' | 'Item key'   | 'Unit' |
			| 'Chewing gum' | '2,000'    | 'Mint/Mango' | 'pcs'  |
			| 'Skittles'    | '2,000'    | 'Fruit'      | 'pcs'  |
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberUnbundling0029611$$"
		And I save the window as "$$Unbundling0029611$$"
		And I click "Post and close" button
		* Check the creation of Unbundling
			And "List" table contains lines
				| 'Item key bundle' | 'Company'      |
				| 'Skittles + Chewing gum/Skittles+Chewing gum'       | 'Main Company' |
		And I close all client application windows

Scenario: _029612 create Unbundling (Store use Goods receipt and doesn't use Shipment confirmation)
	* Opening the creation form Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I click the button named "FormCreate"
	// * Change number
	// 		And I input "8" text in "Number" field
	// 		Then "1C:Enterprise" window is opened
	// 		And I click "Yes" button
	// 		And I input "8" text in "Number" field
	* Filling in details
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| Description |
			| Bound Dress+Shirt       |
		And I select current line in "List" table
		And I click Select button of "Item key bundle" field
		And I go to line in "List" table
			| Item              | Item key  |
			| Bound Dress+Shirt | Bound Dress+Shirt/Dress+Shirt |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| Description |
			| pcs      |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 07  |
		And I select current line in "List" table
		And I move to "Item list" tab
		And in the table "ItemList" I click "By specification" button
	* Check movements
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberUnbundling0029612$$"
		And I save the window as "$$Unbundling0029612$$"
		And Delay 5
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$Unbundling0029612$$'                 | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| 'Document registrations records'        | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''         | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Receipt basis'                 | 'Item key' | 'Row key' |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 07'   | '$$Unbundling0029612$$'         | 'XS/Blue'  | '*'       |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 07'   | '$$Unbundling0029612$$'         | '36/Red'   | '*'       |
			| ''                                      | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''         | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'                      | ''         | ''        |
			| ''                                      | 'Expense'     | '*'      | '2'         | 'Store 07'   | 'Bound Dress+Shirt/Dress+Shirt' | ''         | ''        |
			| ''                                      | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''         | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'                      | ''         | ''        |
			| ''                                      | 'Expense'     | '*'      | '2'         | 'Store 07'   | 'Bound Dress+Shirt/Dress+Shirt' | ''         | ''        |
		And I close all client application windows
	
Scenario: _029613 create Unbundling (Store use Shipment confirmation and does not use Goods receipt)
	* Opening the creation form
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I click the button named "FormCreate"
	// * Change number
	// 		And I input "9" text in "Number" field
	// 		Then "1C:Enterprise" window is opened
	// 		And I click "Yes" button
	// 		And I input "9" text in "Number" field
	* Filling in details
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| Description |
			| Bound Dress+Shirt       |
		And I select current line in "List" table
		And I click Select button of "Item key bundle" field
		And I go to line in "List" table
			| Item              | Item key  |
			| Bound Dress+Shirt | Bound Dress+Shirt/Dress+Shirt |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| Description |
			| pcs      |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 08  |
		And I select current line in "List" table
		And I move to "Item list" tab
		And in the table "ItemList" I click "By specification" button
	* Check movements
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberUnbundling0029613$$"
		And I save the window as "$$Unbundling0029613$$"
		And Delay 5
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$Unbundling0029613$$'                 | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| 'Document registrations records'        | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| 'Register  "Goods in transit outgoing"' | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''                              | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Shipment basis'                | 'Item key'                      | 'Row key' |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | '$$Unbundling0029613$$'         | 'Bound Dress+Shirt/Dress+Shirt' | '*'       |
			| ''                                      | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''                              | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'                      | ''                              | ''        |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | 'XS/Blue'                       | ''                              | ''        |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | '36/Red'                        | ''                              | ''        |
			| ''                                      | 'Expense'     | '*'      | '2'         | 'Store 08'   | 'Bound Dress+Shirt/Dress+Shirt' | ''                              | ''        |
			| ''                                      | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''                              | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'                      | ''                              | ''        |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | 'XS/Blue'                       | ''                              | ''        |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | '36/Red'                        | ''                              | ''        |
		And I close all client application windows



Scenario: _029612 check the output of the document movement report for Unbundling
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberUnBundling0029601$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$UnBundling0029601$$'          | ''            | ''       | ''          | ''           | ''          |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock reservation"'  | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |
		| ''                               | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock balance"'      | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |

	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberUnBundling0029601$$' |    
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$UnBundling0029601$$'          | ''            | ''       | ''          | ''           | ''          |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock reservation"'  | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |
		| ''                               | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock balance"'      | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |

	And I close all client application windows

Scenario: _02961201 clear movements Unbundling and check that there is no movements on the registers 
	* Open list form Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberUnBundling0029601$$'  |    
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Stock reservation"'  |
			| 'Register  "Stock balance"'      |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberUnBundling0029601$$' |     
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document contains lines:
		| '$$UnBundling0029601$$'                  | ''            | ''       | ''          | ''           | ''          |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock reservation"'  | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |
		| ''                               | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock balance"'      | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |
		And I close all client application windows


Scenario: _300520 check connection to Unbundling report "Related documents"
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberUnbundling0029601$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows