#language: en

@tree
@Positive
@LinkedTransaction

Functionality: locking linked strings (RSR, RRR)



Scenario: _2069001 preparation (locking linked strings)
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
	When Create catalog RetailCustomers objects (check POS)
	When create PaymentTypes
	When Create Retail sales receipt, Retail return receipt (locking linked strings)
	And I execute 1C:Enterprise script at server
		| "Documents.RetailSalesReceipt.FindByNumber(51).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.RetailReturnReceipt.FindByNumber(51).GetObject().Write(DocumentWriteMode.Posting);" |

Scenario: _2069002 check locking header in the Retail sales receipt with linked documents (one session)
	And I close all client application windows
	* Open Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Store" attribute is read-only
		And "Company" attribute is read-only
		And "Partner" attribute is read-only
		And "Retail customer" attribute is read-only
		And "Legal name" attribute is read-only
		And "Partner term" attribute is read-only
		And I move to "Other" tab		
		And "Price includes tax" attribute is read-only
		And "Use partner transactions" attribute is read-only
		And "Currency" attribute is read-only
		And "Branch" attribute is read-only
	And I close all client application windows

Scenario: _2069003 check locking header in the Retail return receipt with linked documents (one session)
	And I close all client application windows
	* Open Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Store" attribute is read-only
		And "Company" attribute is read-only
		And "Partner" attribute is read-only
		And "Retail customer" attribute is read-only
		And "Legal name" attribute is read-only
		And "Partner term" attribute is read-only
		And I move to "Other" tab		
		And "Price includes tax" attribute is read-only
		And "Use partner transactions" attribute is read-only
		And "Currency" attribute is read-only
		And "Branch" attribute is read-only
	And I close all client application windows


Scenario: _2069005 check locking tab in the Retail sales receipt with linked documents (one session)
	And I close all client application windows
	* Open RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
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
				| 'Boots' | '37/18SD'  |
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
				| 'Boots' | '37/18SD'  |
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
		* Store
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Store" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Store" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			And I click choice button of "Store" attribute in "ItemList" table
			And I close current window


Scenario: _2069006 check locking tab in the Retail return receipt with linked documents (one session)
	And I close all client application windows
	* Open RRR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '51'     | 
		And I select current line in "List" table
	* Add new string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  |
			| 'Boots' |
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
				| 'Boots' | '36/18SD'  |
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
				| 'Boots' | '36/18SD'  |
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
		* Store
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Store" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Store" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			And I click choice button of "Store" attribute in "ItemList" table
			And I close current window
		* Retail sales receipt
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Retail sales receipt" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Retail sales receipt" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			And I click choice button of "Retail sales receipt" attribute in "ItemList" table
			And I close current window
		And I close all client application windows
		
// Scenario: _2068010 change quantity in the linked string in the Retail sales receipt (one session)
// 	* Open RSR
// 		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
// 		And I go to line in "List" table
// 			| 'Number' |
// 			| '51'     |
// 		And I select current line in "List" table
// 	* Change quantity (less then RRR)
// 		And I go to line in "ItemList" table
// 			| 'Item'  | 'Item key' |
// 			| 'Shirt' | '36/Red'   |
// 		And I activate "Q" field in "ItemList" table
// 		And I select current line in "ItemList" table
// 		And I input "3,000" text in "Q" field of "ItemList" table
// 		And I finish line editing in "ItemList" table
// 		And I move to "Payments" tab
// 		And I activate "Amount" field in "Payments" table
// 		And I select current line in "Payments" table
// 		And I input "7 650,00" text in "Amount" field of "Payments" table
// 		And I finish line editing in "Payments" table
// 		And I move to "Item list" tab		
// 		And I click "Post" button
// 		Then "1C:Enterprise" window is opened
// 		And I click "OK" button
// 		Then there are lines in TestClient message log
// 			|'Line No. [2] [Shirt 36/Red] RowID movements remaining: 4 . Required: 3 . Lacking: 1 .'|
// 	* Change quantity (more then RRR)
// 		And I go to line in "ItemList" table
// 			| 'Item'  | 'Item key' |
// 			| 'Shirt' | '36/Red'   |
// 		And I activate "Q" field in "ItemList" table
// 		And I select current line in "ItemList" table
// 		And I input "6,000" text in "Q" field of "ItemList" table
// 		And I finish line editing in "ItemList" table
// 		And I move to "Payments" tab
// 		And I activate "Amount" field in "Payments" table
// 		And I select current line in "Payments" table
// 		And I input "8 700,00" text in "Amount" field of "Payments" table
// 		And I finish line editing in "Payments" table
// 		And I move to "Item list" tab		
// 		And I click "Post and close" button
// 		Then user message window does not contain messages
// 		Then "Retail sales receipts" window is opened
// 		And I close all client application windows

Scenario: _2069015 delete linked string in the Retail sales receipt (one session)
	And I close all client application windows
	* Open Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '51'     |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '36/Red'   |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' |
			| 'Shirt' | '36/Red'   |		
		And Delay 3
		Then there are lines in TestClient message log
			|'Can not delete linked row [2] [Shirt] [36/Red]'|
		And I close all client application windows


// Scenario: _2069019 unpost Retail sales receipt with linked strings (one session)
// 	And I close all client application windows
// 	* Select Retail sales receipt
// 		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
// 		And I go to line in "List" table
// 			| 'Number' |
// 			| '51'     |
// 	* Try unpost Retail sales receipt
// 		And I activate field named "Date" in "List" table
// 		And in the table "List" I click the button named "ListContextMenuUndoPosting"
// 		Then "1C:Enterprise" window is opened
// 		And I click "OK" button
// 	* Check message
// 		Then there are lines in TestClient message log
// 			|'Line No. [1] [Dress XS/Blue] RowID movements remaining: 8 . Required: 0 . Lacking: 8 .'|
// 			|'Line No. [2] [Shirt 36/Red] RowID movements remaining: 4 . Required: 0 . Lacking: 4 .'|		
// 		And I close all client application windows

// Scenario: _2069020 delete Retail sales receipt with linked strings (one session)
// 	And I close all client application windows
// 	* Select Retail sales receipt
// 		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
// 		And I go to line in "List" table
// 			| 'Number' |
// 			| '51'     |
// 	* Try delete Retail sales receipt
// 		And I activate field named "Date" in "List" table
// 		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
// 		Then "1C:Enterprise" window is opened
// 		And I click "Yes" button
// 		Then "1C:Enterprise" window is opened
// 		And I click "OK" button
// 	* Check message
// 		Then there are lines in TestClient message log
// 			|'Line No. [1] [Dress XS/Blue] RowID movements remaining: 8 . Required: 0 . Lacking: 8 .'|
// 			|'Line No. [2] [Shirt 36/Red] RowID movements remaining: 4 . Required: 0 . Lacking: 4 .'|		
// 		And I close all client application windows