#language: en
@tree
@Positive
@StockControl


Feature: check remaining stock control

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario:_800000 preparation (remaining stock control)
	When set True value to the constant
	* Load info
		When Create catalog CancelReturnReasons objects
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Units objects
		When Create catalog Items objects (serial lot numbers)
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects (with remaining stock control)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog Countries objects
		When Create information register Barcodes records
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When create items for work order
		When Create catalog BillOfMaterials objects
		When Create information register Taxes records (VAT)	
	* Stock remaining settings
		When Create information register UserSettings records (remaining stock control)
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number"                             |
				| "$$NumberPurchaseInvoice31004$$"     |
				When create purchase invoice without order (Vendor Ferron, USD, store 01)
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		If "List" table does not contain lines Then
				| "Number"     |
				| "1"          |
			When Create document OpeningEntry objects (stock)
			Given I open hyperlink "e1cib/list/Document.OpeningEntry"
			And I click "Refresh" button
			And I go to line in "List" table
				| 'Number'     |
				| '1'          |
			And in the table "List" I click "Post" button
	* Load documents
		When Create document OpeningEntry objects (stock control serial lot numbers)
		When Create document Unbundling objects
		When Create document StockAdjustmentAsSurplus objects
		When Create document StockAdjustmentAsSurplus objects (stock control serial lot numbers)
		When Create document PhysicalInventory objects
		When Create document PhysicalInventory objects (stock control serial lot numbers)
		When Create document GoodsReceipt objects
		When Create document GoodsReceipt objects (stock control serial lot numbers)
		When Create document SalesReturn objects
		When Create document SalesReturnOrder objects
		When Create document InternalSupplyRequest objects
		When Create document PurchaseOrder objects
		When Create document InventoryTransfer objects
		When Create document InventoryTransferOrder objects
		When Create document GoodsReceipt objects (for stock remaining control)
		When Create document PurchaseInvoice objects (for stock remaining control)
		When Create document PurchaseInvoice objects (stock control serial lot numbers)
		When Create document PurchaseInvoice objects (stock control)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(251).GetObject().Write(DocumentWriteMode.Posting);"     |
			| "Documents.PurchaseInvoice.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document GoodsReceipt objects (stock control)
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(251).GetObject().Write(DocumentWriteMode.Posting);"     |
			| "Documents.GoodsReceipt.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document InventoryTransfer objects (stock control)
		When Create document InventoryTransfer objects (stock control serial lot numbers)
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransfer.FindByNumber(251).GetObject().Write(DocumentWriteMode.Posting);"     |
			| "Documents.InventoryTransfer.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document ItemStockAdjustment objects (stock control)
		When Create document ItemStockAdjustment objects (stock control serial lot numbers)
		And I execute 1C:Enterprise script at server
			| "Documents.ItemStockAdjustment.FindByNumber(251).GetObject().Write(DocumentWriteMode.Posting);"     |
			| "Documents.ItemStockAdjustment.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document PhysicalInventory objects (stock control)
		And I execute 1C:Enterprise script at server
			| "Documents.PhysicalInventory.FindByNumber(251).GetObject().Write(DocumentWriteMode.Posting);"     |
			| "Documents.PhysicalInventory.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailReturnReceipt objects (stock control)
		When Create document RetailReturnReceipt objects (stock control serial lot numbers)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(251).GetObject().Write(DocumentWriteMode.Posting);"     |
			| "Documents.RetailReturnReceipt.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesOrder objects (stock control)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(251).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(252).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesOrderClosing objects (stock control)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrderClosing.FindByNumber(251).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesReturn objects (stock control)
		When Create document SalesReturn objects (stock control serial lot numbers)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(251).GetObject().Write(DocumentWriteMode.Posting);"     |
			| "Documents.SalesReturn.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document StockAdjustmentAsSurplus objects (stock control)
		And I execute 1C:Enterprise script at server
			| "Documents.StockAdjustmentAsSurplus.FindByNumber(251).GetObject().Write(DocumentWriteMode.Posting);"     |
			| "Documents.StockAdjustmentAsSurplus.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesInvoiceobjects (stock control serial lot numbers)
		When Create document SalesInvoice objects (stock control)
		And I close all client application windows
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(251).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document PurchaseInvoice objects (for materials)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(1114).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document PurchaseInvoice and GoodsReceipt objects (stock inventory control)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(1253).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1253).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create information register UserSettings records (Retail document)
		When create SalesInvoice and StockAdjustmentAsSurplus (stock control)
		When Create document Production objects (stock control)
	When create payment terminal
	When create PaymentTypes
	When create bank terms
	* Workstation
		When create Workstation

Scenario:_8000001 check preparation
	When check preparation 

// expense documents

Scenario:_800005 check remaining stock control in the Sales order
		* Create SO (SI before SC, procurement - Stock)
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "110,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
		* Check remaining stock control (store does not use SC and GR)
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use SC and GR)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "OK" button
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use SC and does not use GR)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 08'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "OK" button
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use GR and does not use SC)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 07'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "OK" button
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Change procurement (purchase and cancel) and check remaining stock control
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate "Procurement method" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "ItemList" table
			And I select "No reserve" exact value from "Procurement method" drop-down list in "ItemList" table
			And I click the button named "FormPost"
			And I save the value of "Number" field as "$$NumberSalesOrder1$$"
			Then user message window does not contain messages
		* Change procurement back and set checkbox SC before SI
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate "Procurement method" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I move to "Other" tab	
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Cancel posting SO
			And I click the button named "FormUndoPosting"
			Then user message window does not contain messages

Scenario:_800008 check remaining stock control in the Sales invoice (without SO)
		And I close all client application windows
		* Create SI 
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "110,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
		* Check remaining stock control (store does not use SC and GR)
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use SC and GR)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "OK" button
			And for each line of "ItemList" table I do
				And I remove "Use shipment confirmation" checkbox in "ItemList" table			
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use GR and does not use SC)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 07'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "OK" button
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Change items and post document
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I select current line in "ItemList" table
			And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I delete a line in "ItemList" table
			And I click the button named "FormPost"
			And I save the value of "Number" field as "$$NumberSalesInvoice1$$"
			Then user message window does not contain messages
		* Cancel posting SI
			And I click the button named "FormUndoPosting"
			Then user message window does not contain messages
		And I close all client application windows


Scenario:_800009 check remaining stock control serial lot numbers in the Sales invoice (without SO and SC)
		And I close all client application windows
		* Create SI 
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Product 1 with SLN'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I activate field named "ItemKey" in "List" table
		And I go to line in "List" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		And I select current line in "List" table
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click "Add" button
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number' |
			| 'PZU'   | '8908899879'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "30,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Code' | 'Owner' | 'Serial number' |
			| '13'   | 'PZU'   | '8908899877'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "10,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I close "Select serial lot numbers" window
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "31,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "50,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I remove "Use shipment confirmation" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check remaining stock control
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I activate "1C:Enterprise" window		
		And I click the button named "OK"
		Then I wait that in user messages the "Line No. [1] [Product 1 with SLN PZU] Serial lot number [8908899879] R4010 Actual stocks remaining: 28 . Required: 30 . Lacking: 2 ." substring will appear in 10 seconds
	* Change quantity and post document
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "13,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		Then "Select serial lot numbers" window is opened
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "12,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then user message window does not contain messages
	* Check stock control in the previous period 
		And I save the value of "Number" field as "$$NumberSalesInvoice800009$$"
		* Create second SI (previous date)
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Product 1 with SLN'    |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I activate field named "ItemKey" in "List" table
			And I go to line in "List" table
				| 'Item'                 | 'Item key'    |
				| 'Product 1 with SLN'   | 'PZU'         |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'PZU'   | '8908899879'    |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "17,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Code' | 'Owner' | 'Serial number' |
				| '13'   | 'PZU'   | '8908899877'    |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "30,000" text in "Quantity" field of "SerialLotNumbers" table
			And I click "Ok" button
			And I input "50,00" text in "Price" field of "ItemList" table
			And I remove "Use shipment confirmation" checkbox in "ItemList" table
			And I finish line editing in "ItemList" table
		* Change date
			And I save "CurrentDate() - 3600" in "PreviousDate" variable
			And I move to "Other" tab
			And I input "$PreviousDate$" text in the field named "Date"
			And I move to the next attribute
			Then "Update item list info" window is opened
			And I click "Uncheck all" button
			And I click "OK" button
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Line No. [1] [Product 1 with SLN PZU] Serial lot number [8908899879] R4010 Actual stocks remaining: 16 . Required: 17 . Lacking: 1 .'|
			And I close current window
			And I click "No" button										
	* Cancel posting SI
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                       |
			| '$$NumberSalesInvoice800009$$' |
		And I click the button named "FormUndoPosting"
		Then user message window does not contain messages
		And I close all client application windows



Scenario:_800011 check remaining stock control in the Retail sales receipt					
			And I close all client application windows
		* Create Retail sales receipt
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "110,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
		* Filling in payments tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Account" attribute in "Payments" table
			And I go to line in "List" table
				| 'Description'      |
				| 'Transit Main'     |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "335 600,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I click the button named "FormPost"
		* Check remaining stock control (store does not use SC and GR)
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use SC and GR)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "OK" button
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use SC and does not use GR)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 08'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "OK" button
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use GR and does not use SC)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 07'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "OK" button
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Change items and post document
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I select current line in "ItemList" table
			And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I delete a line in "ItemList" table
		* Filling in payment tab
			And I move to "Payments" tab
			And I select current line in "Payments" table
			And I input "35 200,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I click the button named "FormPost"
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt1$$"
			Then user message window does not contain messages
		* Cancel posting RSR
			And I click the button named "FormUndoPosting"
			Then user message window does not contain messages
		And I close all client application windows


Scenario:_800012 check remaining stock control serial lot numbers in the Retail sales receipt					
	And I close all client application windows
		* Create Retail sales receipt
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Product 1 with SLN'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I activate field named "ItemKey" in "List" table
		And I go to line in "List" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		And I select current line in "List" table
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click "Add" button
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number' |
			| 'PZU'   | '8908899879'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "6,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Code' | 'Owner' | 'Serial number' |
			| '13'   | 'PZU'   | '8908899877'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "50,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I click choice button of "Payment type" attribute in "Payments" table
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "500,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I move to "Item list" tab	
	* Check remaining stock control
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I activate "1C:Enterprise" window		
		And I click the button named "OK"
		Then I wait that in user messages the "Line No. [1] [Product 1 with SLN PZU] Serial lot number [8908899879] R4010 Actual stocks remaining: 5 . Required: 6 . Lacking: 1 ." substring will appear in 10 seconds
	* Change quantity and post document
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		Then "Select serial lot numbers" window is opened
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I go to line in "SerialLotNumbers" table
			| 'Quantity'   | 'Serial lot number'    |
			| '4,000'      | '8908899877'           |
		And I select current line in "SerialLotNumbers" table
		And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button	
		And I click "Post" button
		Then user message window does not contain messages
	* Cancel posting RSR
		And I click the button named "FormUndoPosting"
		Then user message window does not contain messages
		And I close all client application windows


Scenario:_800014 check remaining stock control in the Bundling					
	And I close all client application windows
		* Create Bundling
			Given I open hyperlink "e1cib/list/Document.Bundling"
			And I click the button named "FormCreate"
			And I click Select button of "Item bundle" field
			And I go to line in "List" table
				| 'Description'       |
				| 'Scarf + Dress'     |
			And I select current line in "List" table
			And I click Select button of "Unit" field
			And I go to line in "List" table
				| 'Description'     |
				| 'pcs'             |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And I input "1,000" text in the field named "Quantity"			
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "110,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
		* Check remaining stock control (store does not use SC and GR)
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use SC and GR)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use SC and does not use GR)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 08'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use GR and does not use SC)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 07'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Change items and post document
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I select current line in "ItemList" table
			And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I delete a line in "ItemList" table
			And I click the button named "FormPost"
			And I save the value of "Number" field as "$$NumberBundling1$$"
			Then user message window does not contain messages
		* Cancel posting Bundling
			And I click the button named "FormUndoPosting"
			Then user message window does not contain messages
		And I close all client application windows
		
Scenario:_800017 check remaining stock control in the Stock adjustment as write off		
		And I close all client application windows
		* Create Stock adjustment as write off
			Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
			And I click the button named "FormCreate"	
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Shop 01'         |
			And I select current line in "List" table
			And I activate "Expense type" field in "ItemList" table
			And I click choice button of "Expense type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Expense'         |
			And I select current line in "List" table		
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "110,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Shop 01'         |
			And I select current line in "List" table
			And I activate "Expense type" field in "ItemList" table
			And I click choice button of "Expense type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Expense'         |
			And I select current line in "List" table	
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Shop 01'         |
			And I select current line in "List" table
			And I activate "Expense type" field in "ItemList" table
			And I click choice button of "Expense type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Expense'         |
			And I select current line in "List" table	
			And I click Choice button of the field named "Currency"
			And I go to line in "List" table
				| 'Description'      |
				| 'Turkish lira'     |
			And I select current line in "List" table			
		* Check remaining stock control (store does not use SC and GR)
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4010 Actual stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4010 Actual stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use SC and GR)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4010 Actual stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4010 Actual stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use SC and does not use GR)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 08'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4010 Actual stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4010 Actual stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use GR and does not use SC)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 07'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4010 Actual stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4010 Actual stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Change items and post document
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I select current line in "ItemList" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I delete a line in "ItemList" table
			And I click the button named "FormPost"
			And I save the value of "Number" field as "$$NumberStockAdjustmentAsWriteOff1$$"
			Then user message window does not contain messages
		* Cancel posting Stock adjustment as write off	
			And I click the button named "FormUndoPosting"
			Then user message window does not contain messages
		And I close all client application windows

Scenario:_800018 check remaining stock control serial lot number in the Stock adjustment as write off		
		And I close all client application windows
		* Create Stock adjustment as write off
			Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
			And I click the button named "FormCreate"	
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table	
		* Add items
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			Then "Items" window is opened
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 1 with SLN' |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item'                  | 'Item key'     |
				| 'Product 1 with SLN'    | 'PZU'          |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			Then "Item serial/lot numbers" window is opened
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'PZU'   | '8908899879'    |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "6,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'PZU'   | '8908899877'    |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate "Profit loss center" field in "ItemList" table
			And I click choice button of "Profit loss center" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'              |
				| 'Logistics department'     |
			And I select current line in "List" table
			And I activate "Expense type" field in "ItemList" table
			And I click choice button of "Expense type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'    | 'Is expense'    | 'Is financial movement type'    | 'Is revenue'     |
				| 'Expense'        | 'Yes'           | 'No'                            | 'No'             |
			And I activate field named "Description" in "List" table
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I click Choice button of the field named "Currency"
			And I go to line in "List" table
				| 'Description'      |
				| 'Turkish lira'     |
			And I select current line in "List" table	
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I activate "1C:Enterprise" window		
			And I click the button named "OK"
	* Check remaining stock control
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I activate "1C:Enterprise" window		
		And I click the button named "OK"
		Then I wait that in user messages the "Line No. [1] [Product 1 with SLN PZU] Serial lot number [8908899879] R4010 Actual stocks remaining: 5 . Required: 6 . Lacking: 1 ." substring will appear in 10 seconds
	* Change quantity and post document
		And I move to "Items" tab	
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		Then "Select serial lot numbers" window is opened
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I go to line in "SerialLotNumbers" table
			| 'Quantity'   | 'Serial lot number'    |
			| '4,000'      | '8908899877'           |
		And I select current line in "SerialLotNumbers" table
		And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button	
		And I click "Post" button
		Then user message window does not contain messages
	* Cancel posting Stock adjustment as write off
		And I click the button named "FormUndoPosting"
		Then user message window does not contain messages
		And I close all client application windows	
								

Scenario:_800020 check remaining stock control in the Purchase return				
		And I close all client application windows
		* Create Purchase return (without Purchase return order)
			Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'DFC'             |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'     |
				| 'DFC'             |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                 |
				| 'Partner term vendor DFC'     |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "110,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table		
		* Check remaining stock control (store does not use SC and GR)
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Change items and post document
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I select current line in "ItemList" table
			And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I delete a line in "ItemList" table
			And I click the button named "FormPost"
			And I save the value of "Number" field as "$$NumberPurchaseReturn1$$"
			Then user message window does not contain messages
		* Cancel posting PR
			And I click the button named "FormUndoPosting"
			Then user message window does not contain messages
		And I close all client application windows										

Scenario:_800021 check remaining stock control in the Purchase return				
	And I close all client application windows
	* Create Purchase return (without Purchase return order)
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'DFC'            |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'    |
			| 'DFC'            |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                |
			| 'Partner term vendor DFC'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table								
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Product 1 with SLN'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I activate field named "ItemKey" in "List" table
		And I go to line in "List" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		And I select current line in "List" table
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click "Add" button
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number' |
			| 'PZU'   | '8908899879'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "6,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Code' | 'Owner' | 'Serial number' |
			| '13'   | 'PZU'   | '8908899877'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "50,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check remaining stock control
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I activate "1C:Enterprise" window		
		And I click the button named "OK"
		Then I wait that in user messages the "Line No. [1] [Product 1 with SLN PZU] Serial lot number [8908899879] R4010 Actual stocks remaining: 5 . Required: 6 . Lacking: 1 ." substring will appear in 10 seconds
	* Change quantity and post document
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		Then "Select serial lot numbers" window is opened
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I go to line in "SerialLotNumbers" table
			| 'Quantity'   | 'Serial lot number'    |
			| '4,000'      | '8908899877'           |
		And I select current line in "SerialLotNumbers" table
		And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button	
		And I click "Post" button
		Then user message window does not contain messages
	* Cancel posting PR
		And I click the button named "FormUndoPosting"
		Then user message window does not contain messages
		And I close all client application windows


Scenario:_800022 check remaining stock control in the shipment confirmation			
		And I close all client application windows
		* Create Shipment confirmation
			Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
			And I click the button named "FormCreate"	
			And I select "Sales" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
			And I select current line in "List" table		
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "110,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table	
		* Check remaining stock control (store use SC and GR)
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Check remaining stock control (store use SC and does not use GR)	
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 08'        |
			And I select current line in "List" table
			And I click "Yes" button			
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress Dress/A-8] R4011 Free stocks remaining: 100 . Required: 110 . Lacking: 10 ." substring will appear in 10 seconds
			Then I wait that in user messages the "Line No. [3] [Trousers 38/Yellow] R4011 Free stocks remaining: 0 . Required: 1 . Lacking: 1 ." substring will appear in 10 seconds
		* Change items and post document
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'      |
				| 'Dress'    | 'Dress/A-8'     |
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I select current line in "ItemList" table
			And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I delete a line in "ItemList" table
			And I click the button named "FormPost"
			And I save the value of "Number" field as "$$NumberShipmentConfirmation1$$"
			Then user message window does not contain messages
		* Cancel posting SC
			And I click the button named "FormUndoPosting"
			Then user message window does not contain messages
		And I close all client application windows


Scenario:_800023 check remaining stock control serial lot number in the shipment confirmation			
	And I close all client application windows
	* Create Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"	
		And I select "Sales" exact value from "Transaction type" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table		
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
	* Add items
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Product 1 with SLN'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I activate field named "ItemKey" in "List" table
		And I go to line in "List" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		And I select current line in "List" table
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click "Add" button
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number' |
			| 'PZU'   | '8908899879'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "6,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Code' | 'Owner' | 'Serial number' |
			| '13'   | 'PZU'   | '8908899877'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check remaining stock control
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I activate "1C:Enterprise" window		
		And I click the button named "OK"
		Then I wait that in user messages the "Line No. [1] [Product 1 with SLN PZU] Serial lot number [8908899879] R4010 Actual stocks remaining: 5 . Required: 6 . Lacking: 1 ." substring will appear in 10 seconds
	* Change quantity and post document
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		Then "Select serial lot numbers" window is opened
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I go to line in "SerialLotNumbers" table
			| 'Quantity'   | 'Serial lot number'    |
			| '4,000'      | '8908899877'           |
		And I select current line in "SerialLotNumbers" table
		And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button	
		And I click "Post" button
		Then user message window does not contain messages
	* Cancel posting SC
		And I click the button named "FormUndoPosting"
		Then user message window does not contain messages
		And I close all client application windows



// incoming documents

	
Scenario:_800032 check remaining stock control when unpost/change Unbundling
	* Post Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I input current date and time in "Date" field
		And I click the button named "FormPost"
		Then user message window does not contain messages
	* Change quantity for Item bundle (more than there is on the remains)
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I input "105,000" text in "Quantity" field
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "[Dress Dress/A-8] R4011 Free stocks remaining: 102 . Required: 105 . Lacking: 3 ." substring will appear in 10 seconds
	* Change quantity back
		And I input "10,000" text in "Quantity" field
		And I save "CurrentDate() - 10800" in "$$$$PreviousDate1$$$$" variable
		And I input "$$$$PreviousDate1$$$$" variable value in "Date" field
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I delete "$$NumberUnbundling1$$" variable
		And I save the value of "Number" field as "$$NumberUnbundling1$$"
		And I close all client application windows
	* Post Sales order and try unpost Unbundling (check reserve)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/Brown'     |
		And I activate "Item key" field in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "20,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I delete "$$NumberSalesOrder2$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder2$$"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [3] [Dress M/Brown] R4011 Free stocks remaining: 20 . Required: 0 . Lacking: 20 ." substring will appear in 10 seconds
	* Change quantity in the Unbundling
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'    |
			| 'Dress'   | 'M/Brown'    | '2,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [3] [Dress M/Brown] R4011 Free stocks remaining: 20 . Required: 10 . Lacking: 10 ." substring will appear in 10 seconds
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/Brown'     |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
	* Create Sales invoice (quantity more than free stock balance)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/Brown'     |
		And I activate "Item key" field in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "11,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [Dress M/Brown] R4011 Free stocks remaining: 10 . Required: 11 . Lacking: 1 ." substring will appear in 10 seconds
		And I close all client application windows
		

Scenario:_800036 check remaining stock control when unpost/change Sales return
	And I close all client application windows
	* Try unpost (balances written off by SI)
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [High shoes 39/19SD] R4011 Free stocks remaining: 160 . Required: 0 . Lacking: 160 ." substring will appear in 10 seconds
		Then I wait that in user messages the "Line No. [2] [Bag ODS] R4011 Free stocks remaining: 40 . Required: 0 . Lacking: 40 ." substring will appear in 10 seconds
	* Try change quantity (less than in the SI)
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '39/19SD'     |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "6,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [High shoes 39/19SD] R4011 Free stocks remaining: 160 . Required: 128 . Lacking: 32 ." substring will appear in 10 seconds
	* Delete string and try to post
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '39/19SD'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [2] [High shoes 39/19SD] R4011 Free stocks remaining: 160 . Required: 80 . Lacking: 80 ." substring will appear in 10 seconds
		And I close all client application windows
	* Add one more string and check posting
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I input "100" text in "Landed cost" field of "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I close all client application windows


Scenario:_800040 check remaining stock control when unpost/change Stock adjustment as surplus
	* Try unpost Stock adjustment as surplus (balances written off by SI)
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [High shoes 39/19SD] R4011 Free stocks remaining: 10 . Required: 0 . Lacking: 10 ." substring will appear in 10 seconds
	* Try change quantity in StockAdjustmentAsSurplus (less than in the SI)
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "6,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"	
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [High shoes 39/19SD] R4011 Free stocks remaining: 10 . Required: 6 . Lacking: 4 ." substring will appear in 10 seconds
	* Delete string from StockAdjustmentAsSurplus and try to post
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '39/19SD'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [] [High shoes 39/19SD] R4011 Free stocks remaining: 10 . Required: 0 . Lacking: 10 ." substring will appear in 10 seconds
		And I close all client application windows
	* Add one more string and check posting
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I click choice button of "Profit loss center" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Accountants office'    |
		And I select current line in "List" table
		And I click choice button of "Revenue type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Revenue'        |
		And I select current line in "List" table	
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I close all client application windows
	

Scenario:_800042 check remaining stock control when post Physical inventory
	And I close all client application windows
	* Try to post Physical inventory (no balance to write off)
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I input current date and time in "Date" field	
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [2] [Dress XS/Blue] R4011 Free stocks remaining: 0 . Required: 2 . Lacking: 2 ." substring will appear in 10 seconds
		And I delete "$$NumberPhysicalInventory1$$" variable
		And I save the value of "Number" field as "$$NumberPhysicalInventory1$$"
		And I close all client application windows
	* Post PI and GR for Store 05
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '25'        |
		And I click the button named "FormPost"
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
		And I click the button named "FormPost"
	* Try to post Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberPhysicalInventory1$$'    |
		And I select current line in "List" table
		And I input current date and time in "Date" field	
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I close all client application windows
		
	
Scenario:_800043 check remaining stock control when unpost Physical inventory
	* Try unpost Physical inventory (balances written off by SI)
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [2] [High shoes 39/19SD] R4011 Free stocks remaining: 10 . Required: 0 . Lacking: 10 ." substring will appear in 10 seconds
		Then I wait that in user messages the "Line No. [1] [Bag ODS] R4011 Free stocks remaining: 20 . Required: 0 . Lacking: 20 ." substring will appear in 10 seconds
	* Try change quantity (less than in the SI)
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '39/19SD'     |
		And I activate "Phys. count" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "6,000" text in "Phys. count" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [2] [High shoes 39/19SD] R4011 Free stocks remaining: 10 . Required: 6 . Lacking: 4 ." substring will appear in 10 seconds
	* Delete string and try to post
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '39/19SD'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [] [High shoes 39/19SD] R4011 Free stocks remaining: 10 . Required: 0 . Lacking: 10 ." substring will appear in 10 seconds
		And I close all client application windows
	* Add one more string and check posting
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I activate "Phys. count" field in "ItemList" table
		And I input "1,000" text in "Phys. count" field of "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I close all client application windows




Scenario:_800044 check remaining stock control when unpost/change Retail return receipt
	And I close all client application windows
	* Try unpost (balances written off by SI)
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [High shoes 39/19SD] R4011 Free stocks remaining: 10 . Required: 0 . Lacking: 10 ." substring will appear in 10 seconds
		Then I wait that in user messages the "Line No. [2] [Bag ODS] R4011 Free stocks remaining: 20 . Required: 0 . Lacking: 20 ." substring will appear in 10 seconds
	* Try change quantity (less than in the SI)
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '39/19SD'     |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "6,000" text in "Quantity" field of "ItemList" table
		And I input "100" text in "Landed cost" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Item list" tab
		And I move to "Payments" tab
		And I activate "Amount" field in "Payments" table
		And I select current line in "Payments" table
		And I input "3 020,00" text in "Amount" field of "Payments" table
		And I finish line editing in "Payments" table
		And I move to "Item list" tab
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [High shoes 39/19SD] R4011 Free stocks remaining: 10 . Required: 6 . Lacking: 4 ." substring will appear in 10 seconds
	* Delete string and try to post
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '39/19SD'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I move to "Payments" tab
		And I activate "Amount" field in "Payments" table
		And I select current line in "Payments" table
		And I input "20,00" text in "Amount" field of "Payments" table
		And I finish line editing in "Payments" table
		And I move to "Item list" tab
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [] [High shoes 39/19SD] R4011 Free stocks remaining: 10 . Required: 0 . Lacking: 10 ." substring will appear in 10 seconds
		And I close all client application windows
	* Add one more string and check posting
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I input "1,000" text in "Landed cost" field of "ItemList" table
		And I move to "Payments" tab
		And I activate "Amount" field in "Payments" table
		And I select current line in "Payments" table
		And I input "5 370,00" text in "Amount" field of "Payments" table
		And I finish line editing in "Payments" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I close all client application windows


Scenario:_800046 check remaining stock control when post/change Inventory transfer order
	And I close all client application windows
	* Try to post Inventory transfer order (no balance to write off), status Approved
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '200'       |
		And I select current line in "List" table
		And I input current date and time in "Date" field	
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [Shirt 36/Red] R4011 Free stocks remaining: 0 . Required: 25 . Lacking: 25 ." substring will appear in 10 seconds
		Then I wait that in user messages the "Line No. [2] [Shirt 38/Black] R4011 Free stocks remaining: 3 . Required: 20 . Lacking: 17 ." substring will appear in 10 seconds
		And I delete "$$NumberInventoryTransferOrder1$$" variable
		And I save the value of "Number" field as "$$NumberInventoryTransferOrder1$$"
	* Try to post Inventory transfer order (no balance to write off), status Wait
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I select "Wait" exact value from "Status" drop-down list
		And I click the button named "FormPost"
		Then system warning window does not appear
		Then user message window does not contain messages		
	* Change store and post Inventory transfer order with status Approved
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I move to "Item list" tab
		And I activate "Quantity" field in "ItemList" table
		And I go to line in "ItemList" table
		| 'Item'   | 'Item key'   |
		| 'Shirt'  | '36/Red'     |
		And I select current line in "ItemList" table
		And I input "20,000" text in "Quantity" field of "ItemList" table
		And I click the button named "FormPost"
		Then system warning window does not appear
		Then user message window does not contain messages
	* Try post Sales order (reserve)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I activate "Item key" field in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [Shirt 38/Black] R4011 Free stocks remaining: 0 . Required: 5 . Lacking: 5 ." substring will appear in 10 seconds
		And I select "Wait" exact value from "Status" drop-down list
		And I click the button named "FormPost"
		Then system warning window does not appear
		Then user message window does not contain messages
	* Change inventory transfer order and try post SO (status Approved)
		When in opened panel I select "Inventory transfer order 200*"
		Then "Inventory transfer order * dated *" window is opened
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "15,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then system warning window does not appear
		Then user message window does not contain messages
		And I close all client application windows
		
Scenario:_800048 check remaining stock control when unpost/change Inventory transfer		
	And I close all client application windows
	* Try unpost (balances written off by SI)
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [2] [High shoes 39/19SD] R4011 Free stocks remaining: 80 . Required: 0 . Lacking: 80 ." substring will appear in 10 seconds
		Then I wait that in user messages the "Line No. [1] [Bag ODS] R4011 Free stocks remaining: 20 . Required: 0 . Lacking: 20 ." substring will appear in 10 seconds
	* Try change quantity (less than in the SI)
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '39/19SD'     |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "6,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [2] [High shoes 39/19SD] R4011 Free stocks remaining: 80 . Required: 48 . Lacking: 32 ." substring will appear in 10 seconds
	* Delete string and try to post
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '39/19SD'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [] [High shoes 39/19SD] R4011 Free stocks remaining: 80 . Required: 0 . Lacking: 80 ." substring will appear in 10 seconds
		And I close all client application windows
	* Add one more string and check posting
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I close all client application windows
		
		
				
		
		

Scenario:_800050 check remaining stock control when unpost/change Opening entry
	* Trying to unpost Opening entry 
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [10] [High shoes 39/19SD] R4011 Free stocks remaining: 80 . Required: 0 . Lacking: 80 ." substring will appear in 10 seconds
		Then I wait that in user messages the "Line No. [11] [Bag ODS] R4011 Free stocks remaining: 20 . Required: 0 . Lacking: 20 ." substring will appear in 10 seconds
	* Trying to change quantity in the Opening entry (less than is posted SI)
		And I move to "Inventory" tab
		And I go to line in "Inventory" table
			| 'Item'   | 'Item key'   | 'Quantity'   | 'Store'       |
			| 'Bag'    | 'ODS'        | '20,000'     | 'Store 03'    |
		And I select current line in "Inventory" table
		And I input "8,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [13] [Bag ODS] R4011 Free stocks remaining: 20 . Required: 8 . Lacking: 12 ." substring will appear in 10 seconds
		And I close all client application windows
	* Trying to delete string in the Opening entry (less than is posted SI)
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I move to "Inventory" tab
		And I go to line in "Inventory" table
			| 'Item'   | 'Item key'   | 'Quantity'   | 'Store'       |
			| 'Bag'    | 'ODS'        | '20,000'     | 'Store 03'    |
		And I select current line in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryContextMenuDelete"
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [] [Bag ODS] R4011 Free stocks remaining: 20 . Required: 0 . Lacking: 20 ." substring will appear in 10 seconds
		And I close all client application windows
	* Add one more string and check posting
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I move to "Inventory" tab
		And I click "Add" button
		And I select current line in "Inventory" table
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "1,000" text in "Quantity" field of "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 04'       |
		And I select current line in "List" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I close all client application windows

Scenario:_800051 check remaining stock control in the Work Sheet
	And I close all client application windows
	* Create WS
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I click "Create" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I activate field named "MaterialsLineNumber" in "Materials" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Add first work
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I activate field named "MaterialsLineNumber" in "Materials" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Installation'    |
		And I select current line in "List" table
		And I activate field named "ItemListBillOfMaterials" in "ItemList" table
		And I click choice button of the attribute named "ItemListBillOfMaterials" in "ItemList" table
		And I go to line in "List" table
			| 'Description'               |
			| 'Furniture installation'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "MaterialsQuantity" in "Materials" table
		And I go to line in "Materials" table
			| 'Item'         | 'Item (BOM)'   | 'Item key'     | 'Item key (BOM)'   | 'Quantity'    |
			| 'Material 1'   | 'Material 1'   | 'Material 1'   | 'Material 1'       | '2,000'       |
		And I select current line in "Materials" table
		And I input "21,000" text in the field named "MaterialsQuantity" of "Materials" table
		And I finish line editing in "Materials" table
	* Add second work
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Assembly'       |
		And I select current line in "List" table
		And I activate field named "ItemListBillOfMaterials" in "ItemList" table
		And I click choice button of the attribute named "ItemListBillOfMaterials" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Assembly'       |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "MaterialsQuantity" in "Materials" table
		And I go to line in "Materials" table
			| 'Item'         | 'Item (BOM)'   | 'Item key'     | 'Item key (BOM)'   | 'Quantity'    |
			| 'Material 1'   | 'Material 1'   | 'Material 1'   | 'Material 1'       | '2,000'       |
		And I select current line in "Materials" table
		And I input "21,000" text in the field named "MaterialsQuantity" of "Materials" table
		And I finish line editing in "Materials" table
						

Scenario:_800051 check remaining stock control in the Work Sheet
	And I close all client application windows
	* Create WS
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I click "Create" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I activate field named "MaterialsLineNumber" in "Materials" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Add first work
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I activate field named "MaterialsLineNumber" in "Materials" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Installation'    |
		And I select current line in "List" table
		And I activate field named "ItemListBillOfMaterials" in "ItemList" table
		And I click choice button of the attribute named "ItemListBillOfMaterials" in "ItemList" table
		And I go to line in "List" table
			| 'Description'               |
			| 'Furniture installation'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "MaterialsQuantity" in "Materials" table
		And I go to line in "Materials" table
			| 'Item'         | 'Item (BOM)'   | 'Item key'     | 'Item key (BOM)'   | 'Quantity'    |
			| 'Material 1'   | 'Material 1'   | 'Material 1'   | 'Material 1'       | '2,000'       |
		And I select current line in "Materials" table
		And I input "21,000" text in the field named "MaterialsQuantity" of "Materials" table
		And I finish line editing in "Materials" table
	* Add second work
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Assembly'       |
		And I select current line in "List" table
		And I activate field named "ItemListBillOfMaterials" in "ItemList" table
		And I click choice button of the attribute named "ItemListBillOfMaterials" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Assembly'       |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "MaterialsQuantity" in "Materials" table
		And I go to line in "Materials" table
			| 'Item'         | 'Item (BOM)'   | 'Item key'     | 'Item key (BOM)'   | 'Quantity'    |
			| 'Material 1'   | 'Material 1'   | 'Material 1'   | 'Material 1'       | '2,000'       |
		And I select current line in "Materials" table
		And I input "21,000" text in the field named "MaterialsQuantity" of "Materials" table
		And I move to "Other" tab
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code'    |
			| 'TRY'     |
		And I select current line in "List" table		
	* Check stock control
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			| 'Line No. [1] [Material 1 Material 1] R4010 Actual stocks remaining: 10 . Required: 42 . Lacking: 32 .'    |
		And I close all client application windows
				

Scenario:_800052 check remaining stock control in the Work Order
	And I close all client application windows
	* Create WO
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I click "Create" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I activate field named "MaterialsLineNumber" in "Materials" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
		And I select current line in "List" table			
	* Add first work
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I activate field named "MaterialsLineNumber" in "Materials" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Installation'    |
		And I select current line in "List" table
		And I activate field named "ItemListBillOfMaterials" in "ItemList" table
		And I click choice button of the attribute named "ItemListBillOfMaterials" in "ItemList" table
		And I go to line in "List" table
			| 'Description'               |
			| 'Furniture installation'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table	
		And I activate field named "MaterialsQuantity" in "Materials" table
		And I go to line in "Materials" table
			| 'Item'         | 'Item key'     | 'Quantity'    |
			| 'Material 1'   | 'Material 1'   | '2,000'       |
		And I select current line in "Materials" table
		And I input "21,000" text in the field named "MaterialsQuantity" of "Materials" table
		And I finish line editing in "Materials" table
	* Add second work
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Assembly'       |
		And I select current line in "List" table
		And I activate field named "ItemListBillOfMaterials" in "ItemList" table
		And I click choice button of the attribute named "ItemListBillOfMaterials" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Assembly'       |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I activate field named "MaterialsQuantity" in "Materials" table
		And I go to line in "Materials" table
			| 'Item'         | 'Item key'     | 'Quantity'    |
			| 'Material 1'   | 'Material 1'   | '2,000'       |
		And I select current line in "Materials" table
		And I input "21,000" text in the field named "MaterialsQuantity" of "Materials" table
		And I select "Approved" exact value from the drop-down list named "Status"		
	* Check stock control
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			| 'Line No. [1] [Material 1 Material 1] R4011 Free stocks remaining: 10 . Required: 42 . Lacking: 32 .'    |
		And I close all client application windows


Scenario:_800055 check remaining stock control when unpost/change Sales order closing
		And I close all client application windows
	* Trying to unpost 
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [High shoes 39/19SD] R4011 Free stocks remaining: 80 . Required: 0 . Lacking: 80 ." substring will appear in 10 seconds
		Then I wait that in user messages the "Line No. [2] [Bag ODS] R4011 Free stocks remaining: 20 . Required: 0 . Lacking: 20 ." substring will appear in 10 seconds
		And I close all client application windows

Scenario:_800056 check remaining stock control when unpost/change Goods receipt
	* Try unpost (balances written off by SI)
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [High shoes 39/19SD] R4011 Free stocks remaining: 10 . Required: 0 . Lacking: 10 ." substring will appear in 10 seconds
	* Try change quantity (less than in the SI)
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "6,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [High shoes 39/19SD] R4011 Free stocks remaining: 10 . Required: 6 . Lacking: 4 ." substring will appear in 10 seconds
	* Delete string and try to post
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '39/19SD'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [] [High shoes 39/19SD] R4011 Free stocks remaining: 10 . Required: 0 . Lacking: 10 ." substring will appear in 10 seconds
		And I close all client application windows
	* Add one more string and check posting
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table	
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I close all client application windows

Scenario:_800060 check remaining stock control serial lot number when unpost incoming documents
	* Preparation
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(1112).GetObject().Write(DocumentWriteMode.UndoPosting);"    |
	* Try unpost Opening entry 
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [Product 1 with SLN PZU] Serial lot number [8908899879] R4010 Actual stocks remaining: 5 . Required: 0 . Lacking: 5 ." substring will appear in 10 seconds
		And I close all client application windows
	* Try unpost Purchase invoice 
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [2] [Product 1 with SLN PZU] Serial lot number [8908899879] R4010 Actual stocks remaining: 5 . Required: 0 . Lacking: 5 ." substring will appear in 10 seconds
		And I close all client application windows	
	* Try unpost Stock Adjustment as surplus 
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [Product 1 with SLN PZU] Serial lot number [8908899879] R4010 Actual stocks remaining: 5 . Required: 0 . Lacking: 5 ." substring will appear in 10 seconds
		And I close all client application windows
	* Try unpost Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [2] [Product 1 with SLN PZU] Serial lot number [8908899879] R4010 Actual stocks remaining: 5 . Required: 0 . Lacking: 5 ." substring will appear in 10 seconds
		And I close all client application windows
	* Try unpost Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [3] [Product 3 with SLN UNIQ] R4011 Free stocks remaining: 10 . Required: 0 . Lacking: 10 ." substring will appear in 10 seconds
		And I close all client application windows
	* Try unpost Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [2] [Product 1 with SLN PZU] Serial lot number [8908899879] R4010 Actual stocks remaining: 5 . Required: 0 . Lacking: 5 ." substring will appear in 10 seconds
		And I close all client application windows


Scenario:_800062 checkmark removal control Stock balance detail in the Serial lot number
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.SerialLotNumbers"
	And I go to line in "List" table
		| 'Serial number'   |
		| '8908899877'      |
	And I select current line in "List" table
	And I remove checkbox "Stock balance detail"
	And I click "Save and close" button
	Then I wait that in user messages the "[Stock balance detail] cannot be changed, has posted documents" substring will appear in 10 seconds
	And I close all client application windows

Scenario:_800063 try to set mark Batch balance details in the Serial lot number that used in the documents
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.SerialLotNumbers"
	And I go to line in "List" table
		| 'Serial number'   |
		| '8908899877'      |
	And I select current line in "List" table
	And I set checkbox "Batch balance detail"
	And I click "Save and close" button
	Then I wait that in user messages the "[Batch balance detail] cannot be changed, has posted documents" substring will appear in 10 seconds
	And I close all client application windows
	

Scenario:_800070 check stock control in the Stock adjustment as surplus
	And I close all client application windows
	* Preparation
		And I execute 1C:Enterprise script at server
			| "Documents.StockAdjustmentAsSurplus.FindByNumber(2113).GetObject().Write(DocumentWriteMode.Posting);"    |
			| "Documents.StockAdjustmentAsSurplus.FindByNumber(2114).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/data/Document.SalesInvoice?ref=b79ea93fec1998ed11ee0a86b6ab2dc2"
		And I click "Decoration group title collapsed picture" hyperlink
		And I click Open button of the field named "Store"
		And I change checkbox "Negative stock control"
		And I click "Save and close" button
		And I click "Post" button
		And I click Open button of the field named "Store"
		And I change checkbox "Negative stock control"
		And I click "Save and close" button
	* Check stock control in the Stock adjustment as surplus
		Given I open hyperlink "e1cib/data/Document.StockAdjustmentAsSurplus?ref=b79ea93fec1998ed11ee0a86b6ab2dba"
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I select current line in "ItemList" table
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I select current line in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			| 'Line No. [1] [Chewing gum Mint/Mango] R4011 Free stocks remaining: 3 . Required: 2 . Lacking: 1 .'    |
		And I close all client application windows
				

Scenario:_800080 set/remove checkbox Negative stock control from store and check posting document (Negative stock)
	* Remove checkbox
		Given I open hyperlink "e1cib/list/Catalog.Stores"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 06'       |
		And I select current line in "List" table
		And I remove checkbox "Negative stock control"
		And I click "Save and close" button
	* Post SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 06'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'XS/Blue'     |
		And I activate "Item key" field in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "15000,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then system warning window does not appear
		Then user message window does not contain messages
		And I save the window as "$$SalesInvoice800080$$"
	* Set checkbox and try to post SI
		Given I open hyperlink "e1cib/list/Catalog.Stores"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 06'       |
		And I select current line in "List" table
		And I set checkbox "Negative stock control"
		And I click "Save and close" button
		When in opened panel I select "$$SalesInvoice800080$$"
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [Dress XS/Blue] R4011 Free stocks remaining: 0 . Required: 15 000 . Lacking: 15 000 ." substring will appear in 10 seconds
		And I close all client application windows



Scenario:_800082 check of FreeStock balance control without date limitation
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"	
	* Filling main info
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'      |
			| 'Partner term DFC' |
		And I select current line in "List" table
		And I move to "Other" tab
		And I input "31.08.2020 12:00:00" text in the field named "Date"
		And I move to "Item list" tab
		And I select from the drop-down list named "Store" by "Store 01" string
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Dress" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "Dress/A-8" from "Item key" drop-down list by string in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "93,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "10,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Product 3 with SLN" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "UNIQ" from "Item key" drop-down list by string in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "11,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check free stock control
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Line No. [1] [Dress Dress/A-8] R4011 Free stocks remaining: 92 . Required: 93 . Lacking: 1 .'|
		* Change quantity (more then free stock in the second line, first line is the same as quantity in the free stock)
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'Dress/A-8' |
			And I select current line in "ItemList" table
			And I input "92,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'               | 'Item key' |
				| 'Product 3 with SLN' | 'UNIQ'     |
			And I select current line in "ItemList" table
			And I input "11,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Line No. [2] [Product 3 with SLN UNIQ] R4011 Free stocks remaining: 10 . Required: 11 . Lacking: 1 .'|
		* Change qauntity (less then free stock)	
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'Dress/A-8' |
			And I select current line in "ItemList" table
			And I input "92,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'               | 'Item key' |
				| 'Product 3 with SLN' | 'UNIQ'     |
			And I select current line in "ItemList" table
			And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then user message window does not contain messages
			And I click the button named "FormUndoPosting"
		And I close all client application windows
		
						
Scenario:_800083 check stock control in the IT (Store sender does not use stock control, Store receiver Use)
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf11c9f09fc93"	
		And I change checkbox "Negative stock control"
		And I click "Save and close" button
	* Create first IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
		* Filling main info
			And I click Choice button of the field named "Company"
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
			And I activate field named "ItemListLineNumber" in "ItemList" table
			And I click Select button of "Store sender" field
			And I go to line in "List" table
				| 'Company'                  | 'Description' |
				| 'Shared for all companies' | 'Store 08'    |
			And I select current line in "List" table
			And I activate field named "ItemListLineNumber" in "ItemList" table
			And I click Select button of "Store receiver" field
			And I go to line in "List" table
				| 'Company'                  | 'Description' |
				| 'Shared for all companies' | 'Store 02'    |
			And I select current line in "List" table
		* Filling item list
			And I activate field named "ItemListLineNumber" in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "100,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate "Item" field in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '38/18SD'  |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "20,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then user message window does not contain messages
			And I delete "$$InventoryTransfer11$$" variable
			And I delete "$$NumberInventoryTransfer11$$" variable
			And I save the window as "$$InventoryTransfer11$$"
			And I save the value of "Number" field as "$$NumberInventoryTransfer11$$"
			And I click the button named "FormPostAndClose"
	* Create second IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
		* Filling main info
			And I click Choice button of the field named "Company"
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
			And I activate field named "ItemListLineNumber" in "ItemList" table
			And I click Select button of "Store sender" field
			And I go to line in "List" table
				| 'Company'                  | 'Description' |
				| 'Shared for all companies' | 'Store 08'    |
			And I select current line in "List" table
			And I activate field named "ItemListLineNumber" in "ItemList" table
			And I click Select button of "Store receiver" field
			And I go to line in "List" table
				| 'Company'                  | 'Description' |
				| 'Shared for all companies' | 'Store 02'    |
			And I select current line in "List" table
		* Filling item list
			And I activate field named "ItemListLineNumber" in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "101,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate "Item" field in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '38/18SD'  |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "21,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then user message window does not contain messages
			And I delete "$$InventoryTransfer12$$" variable
			And I delete "$$NumberInventoryTransfer12$$" variable
			And I save the window as "$$InventoryTransfer12$$"
			And I save the value of "Number" field as "$$NumberInventoryTransfer12$$"
			And I click the button named "FormPostAndClose"
	* Try unpost first IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberInventoryTransfer11$$' |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I close all client application windows

Scenario:_800085 check stock control in the Production (store with and without stock control for materials)
	And I close all client application windows
	* Select Production document
		Given I open hyperlink "e1cib/data/Document.Production?ref=b7af813f69b829cc11ee83a2de45fa2d"
	* Try post (store use stock control, materials are enough)
		And I click "Post" button
		Then user message window does not contain messages
	* Try post (store use stock control, materials are not enough)
		And I go to line in "Materials" table
			| 'Item'       | 'Item key'   |
			| 'Material 2' | 'Material 2' |
		And I activate "Q" field in "Materials" table
		And I select current line in "Materials" table
		And I input "58,000" text in "Q" field of "Materials" table
		And I finish line editing in "Materials" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Line No. [2] [Material 2 Material 2] R4010 Actual stocks remaining: 20 . Required: 58 . Lacking: 38 .'|	
	* Try post (store not use stock control, materials are not enough)	
		And I activate "Writeoff store" field in "Materials" table
		And I select current line in "Materials" table
		And I click Open button of "Writeoff store" field
		And I remove checkbox "Negative stock control"
		And I click "Save and close" button
		And I finish line editing in "Materials" table
		And I click "Post" button
		Then user message window does not contain messages
		And I activate "Writeoff store" field in "Materials" table
		And I select current line in "Materials" table
		And I click Open button of "Writeoff store" field
		And I set checkbox "Negative stock control"
		And I click "Save and close" button
		And I finish line editing in "Materials" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Line No. [2] [Material 2 Material 2] R4010 Actual stocks remaining: 20 . Required: 58 . Lacking: 38 .'|	
	And I close all client application windows
	

				

						
