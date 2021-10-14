#language: en

@tree
@Positive
@LinkedTransaction

Functionality: locking linked strings (Physical inventory, Stock adjustment as surplus, Stock adjustment as write-off )



Scenario: _2068001 preparation (locking linked strings)
	When set True value to the constant
	And I set "True" value to the constant "EnableLinkedRowsIntegrity"
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When Create Document discount
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CancelReturnReasons objects
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
	* Tax settings
		When filling in Tax settings for company
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
		When add sales tax settings 
	When Create Item with SerialLotNumbers (Phone)
	When Create document OpeningEntry objects (stock)
	When Create Physical inventory, Stock adjustment as surplus, Stock adjustment as write off (locking linked strings)
	And I execute 1C:Enterprise script at server
		| "Documents.PhysicalInventory.FindByNumber(51).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.StockAdjustmentAsSurplus.FindByNumber(51).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.StockAdjustmentAsWriteOff.FindByNumber(51).GetObject().Write(DocumentWriteMode.Posting);" |
	


Scenario: _2068002 check locking header in the PhysicalInventory with linked documents (one session)
	* Open PhysicalInventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Store" attribute is read-only
		And "Status" attribute is read-only
	And I close all client application windows


Scenario: _2068003 check locking header in the StockAdjustmentAsSurplus with linked documents (one session)
	* Open StockAdjustmentAsSurplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Store" attribute is read-only
		And "Company" attribute is not read-only
		And "Branch" attribute is not read-only
	And I close all client application windows

Scenario: _2068004 check locking header in the StockAdjustmentAsWriteOff with linked documents (one session)
	* Open StockAdjustmentAsWriteOff
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Store" attribute is read-only
		And "Company" attribute is not read-only
		And "Branch" attribute is not read-only
	And I close all client application windows


Scenario: _2068005 check locking tab in the PhysicalInventory with linked documents (one session)
	And I close all client application windows
	* Open PhysicalInventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'Dress/A-8'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item" attribute in "ItemList" table'|
		* Item key
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item key" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'Dress/A-8'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item key" attribute in "ItemList" table'|
	And I close all client application windows

Scenario: _2068006 check locking tab in the StockAdjustmentAsSurplus with linked documents (one session)
	And I close all client application windows
	* Open StockAdjustmentAsSurplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item" attribute in "ItemList" table'|
		* Item key
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item key" attribute in "ItemList" table'|
		* Basis document
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Basis document" attribute in "ItemList" table'|
		* Physical inventory
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Physical inventory" attribute in "ItemList" table'|
	And I close all client application windows

Scenario: _2068007 check locking tab in the StockAdjustmentAsWriteOff with linked documents (one session)
	And I close all client application windows
	* Open StockAdjustmentAsWriteOff
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'Dress/A-8'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item" attribute in "ItemList" table'|
		* Item key
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'Dress/A-8'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item key" attribute in "ItemList" table'|
		* Basis document
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'Dress/A-8'  |
			When I Check the steps for Exception
				|'And I click choice button of "Basis document" attribute in "ItemList" table'|
		* Physical inventory
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'Dress/A-8'  |
			When I Check the steps for Exception
				|'And I click choice button of "Physical inventory" attribute in "ItemList" table'|
	And I close all client application windows

Scenario: _2068010 change quantity in the linked string in the Physical inventory (one session)
	* Open Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Change quantity (less then surplus)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I input "54,000" text in "Phys. count" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			|'Line No. [1] [Dress XS/Blue] RowID movements remaining: 5 . Required: 4 . Lacking: 1 .'|
	* Change quantity (more then surplus)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I input "56,000" text in "Phys. count" field of "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Physical inventories" window is opened
		And I close all client application windows
	* Change quantity (less then write off)
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'Dress/A-8'  |
		And I input "98,000" text in "Phys. count" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			|'Line No. [2] [Dress Dress/A-8] RowID movements remaining: 3 . Required: 2 . Lacking: 1 .'|
	* Change quantity (more then write off)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'Dress/A-8'  |
		And I input "96,000" text in "Phys. count" field of "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Physical inventories" window is opened
		And I close all client application windows

Scenario: _2068015 delete linked string in the Physical inventory (one session)
	And I close all client application windows
	* Open Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'Dress/A-8'  |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' |
			| 'Dress' | 'Dress/A-8'  |		
		And Delay 3
		Then there are lines in TestClient message log
			|'Can not delete linked row [2] [Dress] [Dress/A-8]'|
		And I close all client application windows

Scenario: _2068019 unpost Physical inventory with linked strings (one session)
	And I close all client application windows
	* Select Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
	* Try unpost Physical inventory
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Dress XS/Blue] RowID movements remaining: 5 . Required: 0 . Lacking: 5 .'|
			|'Line No. [2] [Dress Dress/A-8] RowID movements remaining: 3 . Required: 0 . Lacking: 3 .'|		
		And I close all client application windows

Scenario: _2068020 delete Physical inventory with linked strings (one session)
	And I close all client application windows
	* Select Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
	* Try delete Physical inventory
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Dress XS/Blue] RowID movements remaining: 5 . Required: 0 . Lacking: 5 .'|
			|'Line No. [2] [Dress Dress/A-8] RowID movements remaining: 3 . Required: 0 . Lacking: 3 .'|		
		And I close all client application windows
