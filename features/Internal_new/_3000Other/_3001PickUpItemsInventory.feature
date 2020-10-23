#language: en
@tree
@Positive
@Other

Feature: check form of selection of item in store documents



Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _3001000 preparation
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
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
	* Check or create Purchase invoice 30010001
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice30010001$$" |
				And I click the button named "FormCreate"
				* Filling in details
					And I click Select button of "Company" field
					And I go to line in "List" table
						| Description  |
						| Main Company |
					And I select current line in "List" table
					And I click Select button of "Partner" field
					And I go to line in "List" table
						| 'Description'  |
						| 'Ferron BP'    |
					And I select current line in "List" table
					And I click Select button of "Legal name" field
					And I go to line in "List" table
						| 'Description'  |
						| 'Company Ferron BP'    |
					And I select current line in "List" table
					And I click Select button of "Legal name" field
					And I go to line in "List" table
						| 'Description'  |
						| 'Company Ferron BP'    |
					And I select current line in "List" table
					And I click Select button of "Partner term" field
					And I go to line in "List" table
						| 'Description'  |
						| 'Vendor Ferron, TRY'    |
					And I select current line in "List" table
					And I click Select button of "Store" field
					Then "Stores" window is opened
					And I go to line in "List" table
						| 'Description' |
						| 'Store 05'  |
					And I select current line in "List" table
				* Filling in items table
					And I move to "Item list" tab
					And I click the button named "Add"
					And I click choice button of "Item" attribute in "ItemList" table
					And I go to line in "List" table
						| 'Description' |
						| 'Dress'    |
					And I select current line in "List" table
					And I activate "Item key" field in "ItemList" table
					And I click choice button of "Item key" attribute in "ItemList" table
					And I go to line in "List" table
						| 'Item key' |
						| 'XS/Blue'  |
					And I select current line in "List" table
					And I activate "Q" field in "ItemList" table
					And I input "197,000" text in "Q" field of "ItemList" table
					And I activate "Price" field in "ItemList" table
					And I input "100,000" text in "Price" field of "ItemList" table
					And I finish line editing in "ItemList" table
					And I click the button named "Add"
					And I click choice button of "Item" attribute in "ItemList" table
					And I go to line in "List" table
						| 'Description' |
						| 'Dress'    |
					And I select current line in "List" table
					And I activate "Item key" field in "ItemList" table
					And I click choice button of "Item key" attribute in "ItemList" table
					And I go to line in "List" table
						| 'Item key' |
						| 'S/Yellow'  |
					And I select current line in "List" table
					And I activate "Q" field in "ItemList" table
					And I input "134,000" text in "Q" field of "ItemList" table
					And I activate "Price" field in "ItemList" table
					And I input "100,000" text in "Price" field of "ItemList" table
					And I finish line editing in "ItemList" table
					And I click the button named "Add"
					And I click choice button of "Item" attribute in "ItemList" table
					And I go to line in "List" table
						| 'Description' |
						| 'Shirt'    |
					And I select current line in "List" table
					And I activate "Item key" field in "ItemList" table
					And I click choice button of "Item key" attribute in "ItemList" table
					And I go to line in "List" table
						| 'Item key' |
						| '36/Red'  |
					And I select current line in "List" table
					And I activate "Q" field in "ItemList" table
					And I input "7,000" text in "Q" field of "ItemList" table
					And I activate "Price" field in "ItemList" table
					And I input "100,000" text in "Price" field of "ItemList" table
					And I finish line editing in "ItemList" table
					And I click the button named "Add"
					And I click choice button of "Item" attribute in "ItemList" table
					And I go to line in "List" table
						| 'Description' |
						| 'Boots'    |
					And I select current line in "List" table
					And I activate "Item key" field in "ItemList" table
					And I click choice button of "Item key" attribute in "ItemList" table
					And I go to line in "List" table
						| 'Item key' |
						| '36/18SD'  |
					And I select current line in "List" table
					And I activate "Q" field in "ItemList" table
					And I input "4,000" text in "Q" field of "ItemList" table
					And I activate "Price" field in "ItemList" table
					And I input "100,000" text in "Price" field of "ItemList" table
					And I finish line editing in "ItemList" table
					And I click the button named "FormPost"
					And I delete "$$NumberPurchaseInvoice30010001$$" variable
					And I delete "$$PurchaseInvoice30010001$$" variable
					And I save the value of "Number" field as "$$NumberPurchaseInvoice30010001$$"
					And I save the window as "$$PurchaseInvoice30010001$$"
					And I click the button named "FormPostAndClose"
					Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
					And I go to line in "List" table
						| 'Number' |
						| '$$NumberPurchaseInvoice30010001$$'      |
					And I activate "Date" field in "List" table
					And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
					And I click the button named "FormPostAndClose"
					And I wait "Goods receipt (create)" window closing in 20 seconds						
		* Check or create Purchase invoice 3001002
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice30010002$$" |
				And I click the button named "FormCreate"
				* Filling in details
					And I click Select button of "Company" field
					And I go to line in "List" table
						| Description  |
						| Main Company |
					And I select current line in "List" table
					And I click Select button of "Partner" field
					And I go to line in "List" table
						| 'Description'  |
						| 'Ferron BP'    |
					And I select current line in "List" table
					And I click Select button of "Legal name" field
					And I go to line in "List" table
						| 'Description'  |
						| 'Company Ferron BP'    |
					And I select current line in "List" table
					And I click Select button of "Legal name" field
					And I go to line in "List" table
						| 'Description'  |
						| 'Company Ferron BP'    |
					And I select current line in "List" table
					And I click Select button of "Partner term" field
					And I go to line in "List" table
						| 'Description'  |
						| 'Vendor Ferron, TRY'    |
					And I select current line in "List" table
					And I click Select button of "Store" field
					Then "Stores" window is opened
					And I go to line in "List" table
						| 'Description' |
						| 'Store 06'  |
					And I select current line in "List" table
				* Filling in items table
					And I move to "Item list" tab
					And I click the button named "Add"
					And I click choice button of "Item" attribute in "ItemList" table
					And I go to line in "List" table
						| 'Description' |
						| 'Dress'    |
					And I select current line in "List" table
					And I activate "Item key" field in "ItemList" table
					And I click choice button of "Item key" attribute in "ItemList" table
					And I go to line in "List" table
						| 'Item key' |
						| 'XS/Blue'  |
					And I select current line in "List" table
					And I activate "Q" field in "ItemList" table
					And I input "398,000" text in "Q" field of "ItemList" table
					And I activate "Price" field in "ItemList" table
					And I input "100,000" text in "Price" field of "ItemList" table
					And I finish line editing in "ItemList" table
					And I click the button named "Add"
					And I click choice button of "Item" attribute in "ItemList" table
					And I go to line in "List" table
						| 'Description' |
						| 'Trousers'    |
					And I select current line in "List" table
					And I activate "Item key" field in "ItemList" table
					And I click choice button of "Item key" attribute in "ItemList" table
					And I go to line in "List" table
						| 'Item key' |
						| '36/Yellow'  |
					And I select current line in "List" table
					And I activate "Q" field in "ItemList" table
					And I input "405,000" text in "Q" field of "ItemList" table
					And I activate "Price" field in "ItemList" table
					And I input "100,000" text in "Price" field of "ItemList" table
					And I finish line editing in "ItemList" table
					And I click the button named "FormPost"
					And I delete "$$NumberPurchaseInvoice30010002$$" variable
					And I delete "$$PurchaseInvoice30010002$$" variable
					And I save the value of "Number" field as "$$NumberPurchaseInvoice30010002$$"
					And I save the window as "$$PurchaseInvoice30010002$$"
					And I click the button named "FormPostAndClose"




Scenario: _3001001 check the form of selection of items in the document StockAdjustmentAsWriteOff
	* Open document form
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click the button named "FormCreate"
	* Filling the document header
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'      |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'      |
		And I select current line in "List" table
	* Check the form of selection items
		When check the product selection form in StockAdjustmentAsWriteOff/StockAdjustmentAsSurplus
	And I close all client application windows


Scenario: _3001002 check the form of selection of items in the document StockAdjustmentAsSurplus
	* Open document form
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click the button named "FormCreate"
	* Filling the document header
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'      |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'      |
		And I select current line in "List" table
	* Check the form of selection items
		When check the product selection form in StockAdjustmentAsWriteOff/StockAdjustmentAsSurplus
	And I close all client application windows

Scenario: 3001003 check the form of selection of items in the document PhysicalInventory
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
	* Filling the document header
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'      |
		And I select current line in "List" table
	* Check the form of selection items
		When check the product selection form in PhysicalInventory
	And I close all client application windows

Scenario: 3001004 check the form of selection of items in the document PhysicalCountByLocation
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I click the button named "FormCreate"
	* Filling the document header
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'      |
		And I select current line in "List" table
	* Check the form of selection items
		When check the product selection form in PhysicalInventory
	And I close all client application windows



Scenario: 3001005 check the form Pick Up items Inventory Transfer Order
	* Open form to create Inventory Transfer Order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Filling the document header Inventory Transfer Order
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'    |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 06'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Check the form of selection items
		When check the product selection form in InventoryTransferOrder/InventoryTransfer
	And I close all client application windows


Scenario: 3001006 check the form Pick Up items Inventory Transfer
	* Open form to create Inventory Transfer Order
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
	* Filling the document header Inventory Transfer
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'    |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 06'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Check the form of selection items
		When check the product selection form in InventoryTransferOrder/InventoryTransfer
	And I close all client application windows

Scenario: 3001007 check the form Pick Up items Internal supply request
	* Open form to create Internal supply request
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click the button named "FormCreate"
	* Filling the document header Internal supply request
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Check the form of selection items
		When check the product selection form in StockAdjustmentAsWriteOff/StockAdjustmentAsSurplus
	And I close all client application windows
