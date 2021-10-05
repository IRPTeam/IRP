#language: en

@tree
@Positive
@LinkedTransaction

Functionality: locking linked strings (ISR,ITO,IT)



Scenario: _2067001 preparation (locking linked strings)
	When set True value to the constant
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
	When Create ISR,ITO,IT,SC (locking linked strings)
	And I execute 1C:Enterprise script at server
		| "Documents.InternalSupplyRequest.FindByNumber(51).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.InventoryTransferOrder.FindByNumber(51).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.InventoryTransfer.FindByNumber(51).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.ShipmentConfirmation.FindByNumber(51).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.GoodsReceipt.FindByNumber(51).GetObject().Write(DocumentWriteMode.Posting);" |



Scenario: _2067002 check locking header in the ISR with linked documents (one session)
	* Open ISR
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Store" attribute is read-only
		And "Company" attribute is read-only
		And "Branch" attribute is read-only
	And I close all client application windows

Scenario: _2067003 check locking header in the ITO with linked documents (one session)
	* Open ITO
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Store sender" attribute is read-only
		And "Store receiver" attribute is read-only
		And "Company" attribute is read-only
		And "Branch" attribute is read-only
		And "Status" attribute is read-only
	And I close all client application windows

Scenario: _2067004 check locking header in the IT with linked documents (one session)
	And I close all client application windows
	* Open IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Store sender" attribute is read-only
		And "Store receiver" attribute is read-only
		And "Company" attribute is read-only
		And "Branch" attribute is read-only
		And "Use shipment confirmation" attribute is read-only
		And "Use goods receipt" attribute is read-only
	And I close all client application windows		


Scenario: _2067005 check locking tab in the ISR with linked documents (one session)
	* Open ISR
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
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
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Bag'   | 'PZU'  |
			And I click choice button of "Item" attribute in "ItemList" table
			And I close current window
		* Item key
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item key" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item key" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Bag'   | 'PZU'  |
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
		And I close all client application windows


Scenario: _2067006 check locking tab in the ITO with linked documents (one session)
	* Open ITO
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Add one more string
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Bag'         |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item' | 'Item key' |
			| 'Bag'  | 'PZU'      |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table		
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item' | 'Item key' |
				| 'Bag'  | 'PZU'      |
			And I click choice button of "Item" attribute in "ItemList" table
			And I close current window
		* Item key
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item key" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item key" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item' | 'Item key' |
				| 'Bag'  | 'PZU'      |
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
		* Internal supply request
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Internal supply request" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Internal supply request" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item' | 'Item key' |
				| 'Bag'  | 'PZU'      |
			And I click choice button of "Internal supply request" attribute in "ItemList" table
			And I close current window
		* Purchase order
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item' | 'Item key' |
				| 'Bag'  | 'PZU'      |
			And I click choice button of "Purchase order" attribute in "ItemList" table
			And I close current window
			And I click "Post and close" button
			Then user message window does not contain messages			
		And I close all client application windows


Scenario: _2067007 check locking tab in the IT with linked documents (one session)
	And I close all client application windows
	* Open IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Add one more string
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Bag'         |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item' | 'Item key' |
			| 'Bag'  | 'PZU'      |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table		
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item' | 'Item key' |
				| 'Bag'  | 'PZU'      |
			And I click choice button of "Item" attribute in "ItemList" table
			And I close current window
		* Item key
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item key" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item key" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item' | 'Item key' |
				| 'Bag'  | 'PZU'      |
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
		* Inventory transfer order
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Inventory transfer order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Inventory transfer order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item' | 'Item key' |
				| 'Bag'  | 'PZU'      |
			And I click choice button of "Inventory transfer order" attribute in "ItemList" table
			And I close current window
			And I click "Post and close" button
			Then user message window does not contain messages			
		And I close all client application windows

Scenario: _2067013 change quantity in the linked string in the ISR (one session)
	* Open ISR
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Change quantity, unit (less then ITO)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 
			| 'Shirt' | '36/Red'   |
		And I select current line in "ItemList" table
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "8,000" text in "Quantity" field of "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Line No. [4] [Shirt 36/Red] RowID movements remaining: 10 . Required: 8 . Lacking: 2 .'|
	* Change quantity (more then ITO)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '36/Red'   |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "11,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Internal supply request" window is opened
		And I close all client application windows

Scenario: _2067014 change quantity in the linked string in the ITO (one session)
	* Open ITO
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Change quantity, unit (less then IT)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 
			| 'Shirt' | '36/Red'   |
		And I select current line in "ItemList" table
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Quantity" field of "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Line No. [4] [Shirt 36/Red] RowID movements remaining: 8 . Required: 7 . Lacking: 1 .'|
	* Change quantity (more then IT)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '36/Red'   |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "11,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Inventory transfer orders" window is opened
		And I close all client application windows


Scenario: _2067015 change quantity in the linked string in the IT (one session)
	And I close all client application windows
	* Open IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Change quantity, unit (less then SC,GR)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 
			| 'Shirt' | '36/Red'   |
		And I select current line in "ItemList" table
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Quantity" field of "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Line No. [3] [Shirt 36/Red] RowID movements remaining: 8 . Required: 7 . Lacking: 1 .'|
	* Change quantity (more then SC,GR)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '36/Red'   |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "11,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Inventory transfers" window is opened
		And I close all client application windows


Scenario: _2067016 delete linked string in the ISR (one session)
	* Open ISR
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'  |
			| 'Shirt' | 
		And I select current line in "ItemList" table
		And in the table "ItemList" I click "Delete" button	
		And "ItemList" table contains lines
			| 'Item'  |
			| 'Shirt' |			
		And Delay 3
		Then there are lines in TestClient message log
			|'Can not delete linked row [4] [Shirt] [36/Red]'|
		And I close all client application windows


Scenario: _2067017 delete linked string in the ITO (one session)
	And I close all client application windows
	* Open ITO
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'  |
			| 'Shirt' | 
		And I select current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"	
		And "ItemList" table contains lines
			| 'Item'  |
			| 'Shirt' |			
		And Delay 3
		Then there are lines in TestClient message log
			|'Can not delete linked row [4] [Shirt] [36/Red]'|
		And I close all client application windows

Scenario: _2067018 delete linked string in the IT (one session)
	And I close all client application windows
	* Open IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'  |
			| 'Shirt' | 
		And I select current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"	
		And "ItemList" table contains lines
			| 'Item'  |
			| 'Shirt' |			
		And Delay 3
		Then there are lines in TestClient message log
			|'Can not delete linked row [3] [Shirt] [36/Red]'|
		And I close all client application windows

Scenario: _2067019 unpost ISR with linked strings (one session)
	And I close all client application windows
	* Select ISR
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
	* Try unpost ISR
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Dress XS/Blue] RowID movements remaining: 5 . Required: 0 . Lacking: 5 .'|
			|'Line No. [2] [Trousers 38/Yellow] RowID movements remaining: 10 . Required: 0 . Lacking: 10 .'|
			|'Line No. [3] [Trousers 36/Yellow] RowID movements remaining: 15 . Required: 0 . Lacking: 15 .'|
			|'Line No. [4] [Shirt 36/Red] RowID movements remaining: 10 . Required: 0 . Lacking: 10 .'|		
		And I close all client application windows

Scenario: _2067020 unpost ITO with linked strings (one session)
	And I close all client application windows
	* Select ITO
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
	* Try unpost ITO
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [2] [Trousers 38/Yellow] RowID movements remaining: 10 . Required: 0 . Lacking: 10 .'|
			|'Line No. [3] [Trousers 36/Yellow] RowID movements remaining: 15 . Required: 0 . Lacking: 15 .'|
			|'Line No. [4] [Shirt 36/Red] RowID movements remaining: 11 . Required: 0 . Lacking: 11 .'|
			|'Line No. [5] [Boots 37/18SD] RowID movements remaining: 5 . Required: 0 . Lacking: 5 .'|
			|'Line No. [6] [High shoes 37/19SD] RowID movements remaining: 9 . Required: 0 . Lacking: 9 .'|
			|'Line No. [7] [Boots 38/18SD] RowID movements remaining: 132 . Required: 0 . Lacking: 132 .'|			
		And I close all client application windows


Scenario: _2067021 unpost IT with linked strings (one session)
	And I close all client application windows
	* Select IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
	* Try unpost IT
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Trousers 38/Yellow] RowID movements remaining: 9 . Required: 0 . Lacking: 9 .'|
			|'Line No. [1] [Trousers 38/Yellow] RowID movements remaining: 10 . Required: 0 . Lacking: 10 .'|
			|'Line No. [2] [Trousers 36/Yellow] RowID movements remaining: 15 . Required: 0 . Lacking: 15 .'|
			|'Line No. [2] [Trousers 36/Yellow] RowID movements remaining: 15 . Required: 0 . Lacking: 15 .'|
			|'Line No. [3] [Shirt 36/Red] RowID movements remaining: 8 . Required: 0 . Lacking: 8 .'|
			|'Line No. [4] [Boots 37/18SD] RowID movements remaining: 6 . Required: 0 . Lacking: 6 .'|
			|'Line No. [5] [High shoes 37/19SD] RowID movements remaining: 9 . Required: 0 . Lacking: 9 .'|
			|'Line No. [6] [Boots 38/18SD] RowID movements remaining: 144 . Required: 0 . Lacking: 144 .'|
			|'Line No. [7] [Trousers 38/Yellow] RowID movements remaining: 10 . Required: 0 . Lacking: 10 .'|				
		And I close all client application windows

Scenario: _2067036 delete ISR with linked strings (one session)
	And I close all client application windows
	* Select ISR
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
	* Try delete ISR
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Dress XS/Blue] RowID movements remaining: 5 . Required: 0 . Lacking: 5 .'|
			|'Line No. [2] [Trousers 38/Yellow] RowID movements remaining: 10 . Required: 0 . Lacking: 10 .'|
			|'Line No. [3] [Trousers 36/Yellow] RowID movements remaining: 15 . Required: 0 . Lacking: 15 .'|
			|'Line No. [4] [Shirt 36/Red] RowID movements remaining: 10 . Required: 0 . Lacking: 10 .'|		
	And I close all client application windows	

Scenario: _2067037 delete ITO with linked strings (one session)
	And I close all client application windows
	* Select ITO
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
	* Try delete ITO
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [2] [Trousers 38/Yellow] RowID movements remaining: 10 . Required: 0 . Lacking: 10 .'|
			|'Line No. [3] [Trousers 36/Yellow] RowID movements remaining: 15 . Required: 0 . Lacking: 15 .'|
			|'Line No. [4] [Shirt 36/Red] RowID movements remaining: 11 . Required: 0 . Lacking: 11 .'|
			|'Line No. [5] [Boots 37/18SD] RowID movements remaining: 5 . Required: 0 . Lacking: 5 .'|
			|'Line No. [6] [High shoes 37/19SD] RowID movements remaining: 9 . Required: 0 . Lacking: 9 .'|
			|'Line No. [7] [Boots 38/18SD] RowID movements remaining: 132 . Required: 0 . Lacking: 132 .'|			
	And I close all client application windows	

Scenario: _2067038 delete IT with linked strings (one session)
	And I close all client application windows
	* Select IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
	* Try delete IT
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Trousers 38/Yellow] RowID movements remaining: 9 . Required: 0 . Lacking: 9 .'|
			|'Line No. [1] [Trousers 38/Yellow] RowID movements remaining: 10 . Required: 0 . Lacking: 10 .'|
			|'Line No. [2] [Trousers 36/Yellow] RowID movements remaining: 15 . Required: 0 . Lacking: 15 .'|
			|'Line No. [2] [Trousers 36/Yellow] RowID movements remaining: 15 . Required: 0 . Lacking: 15 .'|
			|'Line No. [3] [Shirt 36/Red] RowID movements remaining: 8 . Required: 0 . Lacking: 8 .'|
			|'Line No. [4] [Boots 37/18SD] RowID movements remaining: 6 . Required: 0 . Lacking: 6 .'|
			|'Line No. [5] [High shoes 37/19SD] RowID movements remaining: 9 . Required: 0 . Lacking: 9 .'|
			|'Line No. [6] [Boots 38/18SD] RowID movements remaining: 144 . Required: 0 . Lacking: 144 .'|
			|'Line No. [7] [Trousers 38/Yellow] RowID movements remaining: 10 . Required: 0 . Lacking: 10 .'|		
	And I close all client application windows	