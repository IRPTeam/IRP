#language: en

@tree
@Positive
@LinkedTransaction

Functionality: locking linked strings (PO,PI,GR,PRO,PR)



Scenario: _2066001 preparation (locking linked strings)
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
	When Create PO,PI,GR,PRO,PR (locking linked strings)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.PurchaseInvoice.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.PurchaseOrder.FindByNumber(35).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.PurchaseInvoice.FindByNumber(35).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.PurchaseReturnOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.PurchaseReturn.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.GoodsReceipt.FindByNumber(35).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.GoodsReceipt.FindByNumber(36).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.PurchaseInvoice.FindByNumber(36).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.ShipmentConfirmation.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
		
		

Scenario: _2066002 check locking header in the PO with linked documents (one session)
	* Open PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '35'     |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Store" attribute is read-only
		And "Company" attribute is read-only
		And "Partner" attribute is read-only
		And "Legal name" attribute is read-only
		And "Partner term" attribute is read-only
		And "Status" attribute is read-only
		And I move to "Other" tab		
		And "Price includes tax" attribute is read-only
		And "Currency" attribute is read-only
		And "Branch" attribute is read-only
	And I close all client application windows

Scenario: _2066003 check locking header in the PI with linked documents (one session)
	* Open PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '35'     |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Store" attribute is read-only
		And "Company" attribute is read-only
		And "Partner" attribute is read-only
		And "Legal name" attribute is read-only
		And "Partner term" attribute is read-only
		And I move to "Other" tab	
		And "Price includes tax" attribute is read-only
		And "Currency" attribute is read-only
		And "Branch" attribute is read-only
	And I close all client application windows	

Scenario: _2066004 check locking header in the GR with linked documents (one session)
	* Open GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '36'     |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Store" attribute is read-only
		And "Company" attribute is read-only
		And "Partner" attribute is read-only
		And "Legal name" attribute is read-only
		And "Transaction type" attribute is read-only
		And "Branch" attribute is read-only
	And I close all client application windows	

Scenario: _2066005 check locking tab in the PO with linked documents (one session)
	* Open PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '35'     |
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
				| 'Trousers' | '38/Yellow'  |
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
				| 'Trousers' | '38/Yellow'  |
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
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Store" attribute in "ItemList" table
			And I close current window
		* Cancel
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
// 			When I Check the steps for Exception
//				|'And I set "Cancel" checkbox in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
//			When I Check the steps for Exception
//				|'And I set "Cancel" checkbox in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I set "Cancel" checkbox in "ItemList" table
			And I finish line editing
		* Cancel reason
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Cancel reason" attribute in "ItemList" table'|		
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Cancel reason" attribute in "ItemList" table'|	
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Cancel reason" attribute in "ItemList" table
			And I close "Cancel/Return reasons" window
		* Sales order
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Sales order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Sales order" attribute in "ItemList" table'|
		* Purchase basis
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase basis" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase basis" attribute in "ItemList" table'|
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
		And I close all client application windows
	


Scenario: _2066006 check locking tab in the PI with linked documents (one session)
	* Open PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '36'     |
		And I select current line in "List" table
		* Add new line
			And I click "Add" button
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
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
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
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
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
		* Store
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Store" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Store" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I click choice button of "Store" attribute in "ItemList" table
			And I close current window
		* Use GR
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			// When I Check the steps for Exception
			// 	|'And I remove "Use goods receipt" checkbox in "ItemList" table'|			
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			// When I Check the steps for Exception
			// 	|'And I remove "Use goods receipt" checkbox in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I set "Use goods receipt" checkbox in "ItemList" table
			And I finish line editing
		* Purchase order
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Purchase order" attribute in "ItemList" table
			And I close current window
		* Sales order
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Sales order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Sales order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Sales order" attribute in "ItemList" table
			And I close current window
		* Internal supply request
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Internal supply request" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Internal supply request" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Internal supply request" attribute in "ItemList" table
			And I close current window
		And I close all client application windows


Scenario: _2066007 check locking tab in the GR with linked documents (one session)
	And I close all client application windows
	* Open GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '36'     |
		And I select current line in "List" table
		* Add new line
			And I click "Add" button
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
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
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
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
				| 'Trousers' | '38/Yellow'  |
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
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Store" attribute in "ItemList" table
			And I close current window
		* Receipt basis
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Receipt basis" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Receipt basis" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Receipt basis" attribute in "ItemList" table
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
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Purchase order" attribute in "ItemList" table
			And I close current window
		* Purchase invoice
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase invoice" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase invoice" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Purchase invoice" attribute in "ItemList" table
			And I close current window
		* Sales order
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Sales order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Sales order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Sales order" attribute in "ItemList" table
			And I close current window
		* Sales invoice
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Sales invoice" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Sales invoice" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Sales invoice" attribute in "ItemList" table
			And I close current window
		* Inventory transfer order
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Inventory transfer order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Inventory transfer order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Inventory transfer order" attribute in "ItemList" table
			And I close current window
		* Inventory transfer
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Inventory transfer" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Inventory transfer" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Inventory transfer" attribute in "ItemList" table
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
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Internal supply request" attribute in "ItemList" table
			And I close current window
		* Sales return
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Sales return" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Sales return" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Sales return" attribute in "ItemList" table
			And I close current window
		* Sales return order
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			When I Check the steps for Exception
				|'And I click choice button of "Sales return order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Sales return order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Sales return order" attribute in "ItemList" table
			And I close current window
		And I close all client application windows
		
Scenario: _2066010 change quantity in the linked string in the PO (one session)
	* Open PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '35'     |
		And I select current line in "List" table
	* Change quantity (less then PI)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Shirt' | '36/Red'   | '11,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "9,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			|'Line No. [3] [Shirt 36/Red] RowID movements remaining: 10 . Required: 9 . Lacking: 1 .'|
	* Change quantity (more then PI)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Shirt' | '36/Red'   | '9,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "11,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Purchase orders" window is opened
		And I close all client application windows
		
				
Scenario: _2066011 change quantity in the linked string in the PI, GR after PI, GR exist (one session)
	* Open PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '35'     |
		And I select current line in "List" table
	* Change quantity (less then GR, GR exist)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Boots' | '37/18SD'  | '2,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I activate "Unit" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'pcs'         |
		And I select current line in "List" table	
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			|'Line No. [1] [Boots 37/18SD] RowID movements remaining: 12 . Required: 1 . Lacking: 11 .'|
	* Change quantity (more then GR, GR exist)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Boots' | '37/18SD'  | '1,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "27,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Purchase invoices" window is opened
		And I close all client application windows

				
Scenario: _2066013 change quantity in the linked string in the GR, GR before PI (one session)
	* Open GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '36'     |
		And I select current line in "List" table
	* Change quantity, unit (less then PI)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity'      |
			| 'Shirt' | '36/Red'   | '10,000' |
		And I select current line in "ItemList" table
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "8,000" text in "Quantity" field of "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			|'Line No. [2] [Shirt 36/Red] RowID movements remaining: 10 . Required: 8 . Lacking: 2 .'|
	* Change quantity (more then PI)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity'      |
			| 'Shirt' | '36/Red'   | '8,000' |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "11,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Goods receipts" window is opened
		And I close all client application windows
	
Scenario: _2066015 delete linked string in the PO (one session)
	* Open PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '35'     |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 
			| 'Shirt' | '36/Red'   |
		And I select current line in "ItemList" table
		And I click "Delete" button	
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' |
			| 'Shirt' | '36/Red'   |		
		And Delay 3
		Then there are lines in TestClient message log
			|'Can not delete linked row [3] [Shirt] [36/Red]'|
		And I close all client application windows			

Scenario: _2066016 delete linked string in the PI (one session)
	* Open PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '35'     |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'  |
			| 'Boots' | 
		And I select current line in "ItemList" table
		And I click "Delete" button	
		And "ItemList" table contains lines
			| 'Item'  |
			| 'Boots' |			
		And Delay 3
		Then there are lines in TestClient message log
			|'Can not delete linked row [1] [Boots] [37/18SD]'|
		And I close all client application windows

Scenario: _2066017 delete linked string in the GR (one session)
	And I close all client application windows
	* Open GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '36'     |
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
			|'Can not delete linked row [2] [Shirt] [36/Red]'|
		And I close all client application windows


Scenario: _2066019 unpost PO with linked strings (one session)
	And I close all client application windows
	* Select PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '35'     |
	* Try unpost PO
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Dress XS/Blue] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'|
			|'Line No. [3] [Shirt 36/Red] RowID movements remaining: 11 . Required: 0 . Lacking: 11 .'|
			|'Line No. [4] [Boots 37/18SD] RowID movements remaining: 36 . Required: 0 . Lacking: 36 .'|
			|'Line No. [5] [Service Interner] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'|
		And I close all client application windows

Scenario: _2066020 unpost PI with linked strings (one session)
	And I close all client application windows
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '35'     |
	* Try unpost PI
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Boots 37/18SD] RowID movements remaining: 12 . Required: 0 . Lacking: 12 .'|
	And I close all client application windows
	
Scenario: _2066021 unpost GR with linked strings (one session)
	And I close all client application windows
	* Select GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '36'     |
	* Try unpost GR
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [3] [Boots 37/18SD] RowID movements remaining: 12 . Required: 0 . Lacking: 12 .'|
			|'Line No. [2] [Shirt 36/Red] RowID movements remaining: 10 . Required: 0 . Lacking: 10 .'|		
	And I close all client application windows		
				

Scenario: _2066023 delete PO with linked strings (one session)
	And I close all client application windows
	* Select PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '35'     |
	* Try delete PO
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Dress XS/Blue] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'|
			|'Line No. [3] [Shirt 36/Red] RowID movements remaining: 11 . Required: 0 . Lacking: 11 .'|
			|'Line No. [4] [Boots 37/18SD] RowID movements remaining: 36 . Required: 0 . Lacking: 36 .'|
			|'Line No. [5] [Service Interner] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'|
		And I close all client application windows

Scenario: _2066024 delete PI with linked strings (one session)
	And I close all client application windows
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '35'     |
	* Try delete PI
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Boots 37/18SD] RowID movements remaining: 12 . Required: 0 . Lacking: 12 .'|
	And I close all client application windows
	
Scenario: _2066025 delete GR with linked strings (one session)
	And I close all client application windows
	* Select GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '36'     |
	* Try delete GR
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [3] [Boots 37/18SD] RowID movements remaining: 12 . Required: 0 . Lacking: 12 .'|
			|'Line No. [2] [Shirt 36/Red] RowID movements remaining: 10 . Required: 0 . Lacking: 10 .'|		
	And I close all client application windows

				

Scenario: _2066029 check locking header in the PRO with linked documents (one session)
	And I close all client application windows
	* Open PRO
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '32'     |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Store" attribute is read-only
		And "Company" attribute is read-only
		And "Partner" attribute is read-only
		And "Legal name" attribute is read-only
		And "Partner term" attribute is read-only
		And "Status" attribute is read-only
		And I move to "Other" tab		
		And "Price includes tax" attribute is read-only
		And "Currency" attribute is read-only
		And "Branch" attribute is read-only
	And I close all client application windows
		
Scenario: _2066030 check locking header in the PR with linked documents (one session)
	And I close all client application windows
	* Open PR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number' |
			| '32'     |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Store" attribute is read-only
		And "Company" attribute is read-only
		And "Partner" attribute is read-only
		And "Legal name" attribute is read-only
		And "Partner term" attribute is read-only
		And I move to "Other" tab	
		And "Price includes tax" attribute is read-only
		And "Currency" attribute is read-only
		And "Branch" attribute is read-only
	And I close all client application windows					


Scenario: _2066031 check locking tab in the PRO with linked documents (one session)
	And I close all client application windows
	* Open PRO
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '32'     |
		And I select current line in "List" table
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Item" attribute in "ItemList" table
			And I close current window
		* Item key
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item key" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Item key" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
		* Store
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Store" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Store" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Store" attribute in "ItemList" table
			And I close current window
		* Cancel
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
// 			When I Check the steps for Exception
//				|'And I set "Cancel" checkbox in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
//			When I Check the steps for Exception
//				|'And I set "Cancel" checkbox in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I set "Cancel" checkbox in "ItemList" table
			And I finish line editing
		* Purchase invoice
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase invoice" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase invoice" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Purchase invoice" attribute in "ItemList" table			
			And I close current window
		And I close all client application windows
	


Scenario: _2066032 check locking tab in the PR with linked documents (one session)
	And I close all client application windows
	* Open PR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number' |
			| '32'     |
		And I select current line in "List" table		
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
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
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
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
		* Store
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Store" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Store" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I click choice button of "Store" attribute in "ItemList" table
			And I close current window
		* Use SC
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			// When I Check the steps for Exception
			// 	|'And I remove "Use shipment confirmation" checkbox in "ItemList" table'|			
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			// When I Check the steps for Exception
			// 	|'And I remove "Use shipment confirmation" checkbox in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I set "Use shipment confirmation" checkbox in "ItemList" table
			And I finish line editing
		* Purchase invoice
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase invoice" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase invoice" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Purchase invoice" attribute in "ItemList" table
			And I close current window
		* Purchase return order
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase return order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			When I Check the steps for Exception
				|'And I click choice button of "Purchase return order" attribute in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I click choice button of "Purchase return order" attribute in "ItemList" table
			And I close current window
		And I close all client application windows
	

Scenario: _2066033 unpost PRO with linked strings (one session)
	And I close all client application windows
	* Select PRO
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '32'     |
	* Try unpost SRO
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Shirt 36/Red] RowID movements remaining: 7 . Required: 0 . Lacking: 7 .'|
			|'Line No. [2] [Boots 37/18SD] RowID movements remaining: 4 . Required: 0 . Lacking: 4 .'|				
	And I close all client application windows
	
Scenario: _2066034 unpost PR with linked strings (one session)
	And I close all client application windows
	* Select PR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number' |
			| '32'     |
	* Try unpost PR
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Shirt 36/Red] RowID movements remaining: 7 . Required: 0 . Lacking: 7 .'|				
	And I close all client application windows		
				

Scenario: _2066035 delete PRO with linked strings (one session)
	And I close all client application windows
	* Select PRO
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '32'     |
	* Try delete PRO
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Shirt 36/Red] RowID movements remaining: 7 . Required: 0 . Lacking: 7 .'|
			|'Line No. [2] [Boots 37/18SD] RowID movements remaining: 4 . Required: 0 . Lacking: 4 .'|
		And I close all client application windows

Scenario: _2066036 delete PR with linked strings (one session)
	And I close all client application windows
	* Select PR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number' |
			| '32'     |
	* Try delete PR
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			|'Line No. [1] [Shirt 36/Red] RowID movements remaining: 7 . Required: 0 . Lacking: 7 .'|
	And I close all client application windows		

Scenario: _2066037 delete linked string in the PRO (one session)
	And I close all client application windows
	* Open PRO
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '32'     |
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
			|'Can not delete linked row [1] [Shirt] [36/Red]'|
		And I close all client application windows		
			
Scenario: _2066038 delete linked string in the PR (one session)
	And I close all client application windows
	* Open PR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number' |
			| '32'     |
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
			|'Can not delete linked row [1] [Shirt] [36/Red]'|
		And I close all client application windows	

Scenario: _2066039 change quantity in the linked string in the PRO (one session)
	And I close all client application windows	
	* Open PRO
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '32'     |
		And I select current line in "List" table
	* Change quantity, unit (less then SR)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '36/Red'   |
		And I select current line in "ItemList" table
		And I activate "Q" field in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			|'Line No. [1] [Shirt 36/Red] RowID movements remaining: 7 . Required: 5 . Lacking: 2 .'|
	* Change quantity (more then PR)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '36/Red'   |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "8,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Purchase return orders" window is opened
		And I close all client application windows

Scenario: _2066040 change quantity in the linked string in the PR (one session)
	And I close all client application windows	
	* Open PR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number' |
			| '32'     |
		And I select current line in "List" table
	* Change quantity, unit (less then SC)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '36/Red'   |
		And I select current line in "ItemList" table
		And I activate "Q" field in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			|'Line No. [1] [Shirt 36/Red] RowID movements remaining: 7 . Required: 5 . Lacking: 2 .'|
	* Change quantity (more then SC)
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '36/Red'   |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "8,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Purchase returns" window is opened
		And I close all client application windows