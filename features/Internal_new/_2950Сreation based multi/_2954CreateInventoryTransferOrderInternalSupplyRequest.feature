#language: en
@tree
@Positive
@CreationBasedMulti

Feature: create Inventory transfer order based on several Internal supply request


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _295400 preparation 
	
Scenario: _090500 preparation (create PI and SI based on Goods receipt and Shipment confirmation)
	* Constants
		When set True value to the constant
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
		When Create catalog Companies objects (partners company)
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
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
	* Create first Internal supply request from Store 02
		* Open a creation form Internal Supply Request
			Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
			And I click the button named "FormCreate"
		* Change the document number
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "295" text in "Number" field
		* Filling in basic details
			And I click Select button of "Company" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description  |
				| Main Company | 
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description |
				| Store 02  |
			And I select current line in "List" table
		* Filling in the tabular part
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
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
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'High shoes'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'       | 'Item key' |
				| 'High shoes' | '37/19SD'  |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Create second Internal supply request from Store 02
		* Open a creation form Internal Supply Request
			Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
			And I click the button named "FormCreate"
		* Change the document number
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "296" text in "Number" field
		* Filling in basic details
			And I click Select button of "Company" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description  |
				| Main Company | 
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description |
				| Store 02  |
			And I select current line in "List" table
		* Filling in the tabular part
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Dress' | 'S/Yellow' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
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
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'High shoes'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'       | 'Item key' |
				| 'High shoes' | '37/19SD'  |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Create third Internal supply request from Store 03
		* Open a creation form Internal Supply Request
			Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
			And I click the button named "FormCreate"
		* Change the document number
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "297" text in "Number" field
		* Filling in basic details
			And I click Select button of "Company" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description  |
				| Main Company | 
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description |
				| Store 03  |
			And I select current line in "List" table
		* Filling in the tabular part
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'M/White' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
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
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'High shoes'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'       | 'Item key' |
				| 'High shoes' | '37/19SD'  |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click "Post and close" button


Scenario: _295401 check filling in Inventory transfer order when creating based on two Internal supply requests with the same warehouse
	* Select InternalSupplyRequest
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number'  |
			| '295' | 
		And I move one line down in "List" table and select line
	* Create Inventory transfer order and check filling in
		And I click the button named "FormDocumentInventoryTransferOrderGenerateInventoryTransferOrder"
		And "ItemList" table contains lines
		| 'Item'       | 'Quantity' | 'Internal supply request'      | 'Item key'  | 'Unit' |
		| 'Dress'      | '2,000'    | 'Internal supply request 296*' | 'S/Yellow'  | 'pcs'  |
		| 'Trousers'   | '2,000'    | 'Internal supply request 295*' | '38/Yellow' | 'pcs'  |
		| 'Boots'      | '1,000'    | 'Internal supply request 295*' | '37/18SD'   | 'pcs'  |
		| 'Boots'      | '2,000'    | 'Internal supply request 296*' | '37/18SD'   | 'pcs'  |
		| 'High shoes' | '2,000'    | 'Internal supply request 295*' | '37/19SD'   | 'pcs'  |
		| 'High shoes' | '2,000'    | 'Internal supply request 296*' | '37/19SD'   | 'pcs'  |
	And I close all client application windows

Scenario: _295402 check filling in Inventory transfer order when creating based on two Internal supply requests with the different warehouse
	* Select InternalSupplyRequest
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number'  |
			| '296' | 
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentInventoryTransferOrderGenerateInventoryTransferOrder"
		And I go to line in "Stores" table
			| 'Store'    |
			| 'Store 03' |
		And I set "Use" checkbox in "Stores" table
		And I finish line editing in "Stores" table
		And I click "Ok" button
	* Create Inventory transfer order and check filling in
		And "ItemList" table contains lines
		| 'Item'       | 'Quantity' | 'Internal supply request'      | 'Item key' | 'Unit' |
		| 'Dress'      | '2,000'    | 'Internal supply request 297*' | 'M/White'  | 'pcs'  |
		| 'Boots'      | '2,000'    | 'Internal supply request 297*' | '37/18SD'  | 'pcs'  |
		| 'High shoes' | '2,000'    | 'Internal supply request 297*' | '37/19SD'  | 'pcs'  |
	And I close all client application windows
