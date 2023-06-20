#language: en

@tree
@Positive
@LinkedTransaction


Functionality: locking linked strings (SO,SI,SC,SRO,SR)

Variables:
import "Variables.feature"

Scenario: _2065001 preparation (locking linked strings)
	When set True value to the constant
	When set True value to the constant EnableLinkedRowsIntegrity
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
		When Create catalog Countries objects
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
		When create items for work order
		When Create catalog BillOfMaterials objects
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"            |
				| "TaxCalculateVAT_TR"     |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
	* Add Document discount
		When Create Document discount
		* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	* Tax settings
		When filling in Tax settings for company
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
		When add sales tax settings 
	When Create Item with SerialLotNumbers (Phone)
	When Create document SalesOrder and SalesInvoice objects (creation based on, SI >SO)
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.SalesOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(32).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.SalesInvoice.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create SO,SI,SC,SRO,SR (locking linked strings)
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(35).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.SalesOrder.FindByNumber(35).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(35).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.SalesInvoice.FindByNumber(35).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesReturnOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Write);" |
		| "Documents.SalesReturnOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesReturn.FindByNumber(32).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.SalesReturn.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.ShipmentConfirmation.FindByNumber(35).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.ShipmentConfirmation.FindByNumber(35).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.ShipmentConfirmation.FindByNumber(36).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.ShipmentConfirmation.FindByNumber(36).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(36).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.SalesInvoice.FindByNumber(36).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.GoodsReceipt.FindByNumber(32).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.GoodsReceipt.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create Planned receipt reservation, SO, PO (locking linked strings)
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(36).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseOrder.FindByNumber(36).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.PurchaseOrder.FindByNumber(36).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.PlannedReceiptReservation.FindByNumber(36).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.PlannedReceiptReservation.FindByNumber(36).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document SO-WO-WS-SI
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(182).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.SalesOrder.FindByNumber(182).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.WorkOrder.FindByNumber(31).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.WorkOrder.FindByNumber(31).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.WorkSheet.FindByNumber(3).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.WorkSheet.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(182).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.SalesInvoice.FindByNumber(182).GetObject().Write(DocumentWriteMode.Posting);"   |



Scenario: _20650011 check preparation
	When check preparation

Scenario: _20650011 Info linked documents row
	And I close all client application windows
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
		And I select current line in "List" table
	* Check Info linked documents row
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I activate "Locked row" field in "ItemList" table
		And I select current line in "ItemList" table
		And I activate "Is internal linked" field in "ItemList" table
		And I select current line in "ItemList" table
		Then "Info linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And "BasisesTree" table became equal
			| 'Row presentation'                                     | 'Quantity'   | 'Unit'   | 'Price'    | 'Currency'    |
			| 'Sales order 35 dated 23.09.2021 10:19:43'             | ''           | ''       | ''         | ''            |
			| 'Shipment confirmation 36 dated 23.09.2021 10:20:59'   | ''           | ''       | ''         | ''            |
			| 'Shirt (36/Red)'                                       | '10,000'     | 'pcs'    | '350,00'   | 'TRY'         |
	* Show row key
		And I click "Show row key" button
		And "ResultsTable" table became equal
			| 'Item'    | 'Item key'   | 'Store'      | 'Key'   | 'Basis'                                                | 'Basis unit'   | 'Current step'   | 'Row ref'   | 'Parent basis'   | 'Row ID'   | 'Basis key'   | 'Unit'    |
			| 'Shirt'   | '36/Red'     | 'Store 02'   | '*'     | 'Shipment confirmation 36 dated 23.09.2021 10:20:59'   | 'pcs'          | 'SI'             | '*'         | ''               | '*'        | '*'           | ''        |
	* Try Delete row
		And I go to line in "BasisesTree" table
			| 'Quantity'   | 'Row presentation'    |
			| '10,000'     | 'Shirt (36/Red)'      |
		And I activate current test client window
		And I press keyboard shortcut "Delete"
		And "BasisesTree" table became equal
			| 'Row presentation'                                     | 'Stock quantity'   | 'Quantity'   | 'Unit'   | 'Price'    | 'Row ref'   | 'Currency'   | 'Basis unit'   | 'Basis'                                                | 'Key'                                    | 'Row ID'                                 | 'Basis key'                              | 'Current step'    |
			| 'Sales order 35 dated 23.09.2021 10:19:43'             | ''                 | ''           | ''       | ''         | ''          | ''           | ''             | 'Sales order 35 dated 23.09.2021 10:19:43'             | '                                    '   | '                                    '   | '                                    '   | ''                |
			| 'Shipment confirmation 36 dated 23.09.2021 10:20:59'   | ''                 | ''           | ''       | ''         | ''          | ''           | ''             | 'Shipment confirmation 36 dated 23.09.2021 10:20:59'   | '                                    '   | '                                    '   | '                                    '   | ''                |
			| 'Shirt (36/Red)'                                       | '10,000'           | '10,000'     | 'pcs'    | '350,00'   | '*'         | 'TRY'        | 'pcs'          | 'Shipment confirmation 36 dated 23.09.2021 10:20:59'   | '*'                                      | '*'                                      | '*'                                      | 'SI'              |
	* Try copy row
		And I go to line in "BasisesTree" table
			| 'Quantity'   | 'Row presentation'    |
			| '10,000'     | 'Shirt (36/Red)'      |
		And I activate current test client window
		And I press keyboard shortcut "F9"
		And "BasisesTree" table became equal
			| 'Row presentation'                                     | 'Stock quantity'   | 'Quantity'   | 'Unit'   | 'Price'    | 'Row ref'   | 'Currency'   | 'Basis unit'   | 'Basis'                                                | 'Key'                                    | 'Row ID'                                 | 'Basis key'                              | 'Current step'    |
			| 'Sales order 35 dated 23.09.2021 10:19:43'             | ''                 | ''           | ''       | ''         | ''          | ''           | ''             | 'Sales order 35 dated 23.09.2021 10:19:43'             | '                                    '   | '                                    '   | '                                    '   | ''                |
			| 'Shipment confirmation 36 dated 23.09.2021 10:20:59'   | ''                 | ''           | ''       | ''         | ''          | ''           | ''             | 'Shipment confirmation 36 dated 23.09.2021 10:20:59'   | '                                    '   | '                                    '   | '                                    '   | ''                |
			| 'Shirt (36/Red)'                                       | '10,000'           | '10,000'     | 'pcs'    | '350,00'   | '*'         | 'TRY'        | 'pcs'          | 'Shipment confirmation 36 dated 23.09.2021 10:20:59'   | '*'                                      | '*'                                      | '*'                                      | 'SI'              |
		And I close all client application windows
				
						

Scenario: _2065002 check locking header in the SO with linked documents (one session)
	And I close all client application windows
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '35'        |
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

Scenario: _2065003 check locking header in the SI with linked documents (one session)
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '35'        |
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

Scenario: _2065004 check locking header in the SC with linked documents (one session)
	* Open SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
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


Scenario: _20650041 check locking header in the WS with linked documents (one session)
	And I close all client application windows
	* Open WS
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Company" attribute is read-only
		And "Partner" attribute is read-only
		And "Legal name" attribute is read-only
		And I move to "Other" tab		
		And "Branch" attribute is read-only
	And I close all client application windows


Scenario: _20650042 check locking header in the WO with linked documents (one session)
	* Open WO
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Company" attribute is read-only
		And "Partner" attribute is read-only
		And "Legal name" attribute is read-only
		And "Partner term" attribute is read-only
		And I move to "Other" tab	
		And "Price include tax" attribute is read-only
		And "Currency" attribute is read-only
		And "Branch" attribute is read-only
	And I close all client application windows	


Scenario: _2065005 check locking tab in the SO with linked documents (one session)
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '35'        |
		And I select current line in "List" table
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Item" attribute in "ItemList" table
			And I close current window
		* Item key
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
		* Procurement
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Procurement method" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Procurement method" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Procurement method" attribute in "ItemList" table
			And I finish line editing
		* Store
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Store" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Store" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Store" attribute in "ItemList" table
			And I close current window
		* Cancel
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
// 			When I Check the steps for Exception
//				|'And I set "Cancel" checkbox in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
//			When I Check the steps for Exception
//				|'And I set "Cancel" checkbox in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I set "Cancel" checkbox in "ItemList" table
			And I finish line editing
		* Cancel reason
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Cancel reason" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Cancel reason" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Cancel reason" attribute in "ItemList" table
			And I close "Cancel/Return reasons" window
		And I close all client application windows
	


Scenario: _2065006 check locking tab in the SI with linked documents (one session)
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
		And I select current line in "List" table
		* Add new line
			And in the table "ItemList" I click "Add" button
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table			
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Item" attribute in "ItemList" table
			And I close current window
		* Item key
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
		* Store
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Store" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Store" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Store" attribute in "ItemList" table
			And I close current window
		* Use SC
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			// When I Check the steps for Exception
			// 	|'And I remove "Use shipment confirmation" checkbox in "ItemList" table'|			
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			// When I Check the steps for Exception
			// 	|'And I remove "Use shipment confirmation" checkbox in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I set "Use shipment confirmation" checkbox in "ItemList" table
			And I finish line editing
		* Sales order
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Sales order" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Sales order" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Sales order" attribute in "ItemList" table
			And I close current window
		And I close all client application windows


Scenario: _2065007 check locking tab in the SC with linked documents (one session)
	And I close all client application windows
	* Open SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
		And I select current line in "List" table
		* Add new line
			And I click "Add" button
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table			
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Item" attribute in "ItemList" table
			And I close current window
		* Item key
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
		* Store
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Store" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Store" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Store" attribute in "ItemList" table
			And I close current window
		* Shipment basis
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Shipment basis" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Shipment basis" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Shipment basis" attribute in "ItemList" table
			And I close current window
		* Sales order
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Sales order" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Sales order" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Sales order" attribute in "ItemList" table
			And I close current window
		* Sales invoice
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Sales invoice" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Sales invoice" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Sales invoice" attribute in "ItemList" table
			And I close current window
		And I close all client application windows


Scenario: _20650071 check locking tab in the WS with linked documents (one session)
	And I close all client application windows
	* Open WS
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
		And I select current line in "List" table
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'            | 'Item key'         |
				| 'Installation'    | 'Installation'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     |
				| 'Assembly'    | 'Assembly'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
		* Item key
			And I go to line in "ItemList" table
				| 'Item'            | 'Item key'         |
				| 'Installation'    | 'Installation'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     |
				| 'Assembly'    | 'Assembly'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
		* Sales order
			And I go to line in "ItemList" table
				| 'Item'            | 'Item key'         |
				| 'Installation'    | 'Installation'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Sales order" attribute in "ItemList" table'     |
		* Work order
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     |
				| 'Assembly'    | 'Assembly'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Work order" attribute in "ItemList" table'     |
			And I close all client application windows
			

Scenario: _20650072 check locking tab in the WO with linked documents (one session)
	And I close all client application windows
	* Open WO
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
		And I select current line in "List" table
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'            | 'Item key'         |
				| 'Installation'    | 'Installation'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     |
				| 'Assembly'    | 'Assembly'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
		* Item key
			And I go to line in "ItemList" table
				| 'Item'            | 'Item key'         |
				| 'Installation'    | 'Installation'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     |
				| 'Assembly'    | 'Assembly'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
		* Sales order
			And I go to line in "ItemList" table
				| 'Item'            | 'Item key'         |
				| 'Installation'    | 'Installation'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Sales order" attribute in "ItemList" table'     |
			And I close all client application windows	
						

Scenario: 2065008 check unlock linked rows in the SO
	And I close all client application windows
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
		And I select current line in "List" table
	* Check unlock linked rows
		And I click "Unlock linked rows" button
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'   | 'Item'     |
			| '38/Black'   | 'Shirt'    |
		And I close all client application windows
		
	
Scenario: 2065009 check unlock linked rows in the SI
	And I close all client application windows
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
		And I select current line in "List" table
	* Check unlock linked rows
		And I click "Unlock linked rows" button
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'   | 'Item'     |
			| '38/Black'   | 'Shirt'    |
		And I close all client application windows	

Scenario: 20650091 check unlock linked rows in the SC
	And I close all client application windows
	* Open SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
		And I select current line in "List" table
	* Check unlock linked rows
		And I click "Unlock linked rows" button
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'   | 'Item'     |
			| '38/Black'   | 'Shirt'    |
		And I close all client application windows	

Scenario: 20650092 check unlock linked rows in the WS
	And I close all client application windows
	* Open WS
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
		And I select current line in "List" table
	* Check unlock linked rows
		And I click "Unlock linked rows" button
		And I go to line in "ItemList" table
			| 'Item'           | 'Item key'        |
			| 'Installation'   | 'Installation'    |
		And I select current line in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Assembly'       |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table does not contain lines
			| 'Item'           | 'Item key'        |
			| 'Installation'   | 'Installation'    |
		And I close all client application windows	

Scenario: 20650093 check unlock linked rows in the WO
	And I close all client application windows
	* Open WO
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
		And I select current line in "List" table
	* Check unlock linked rows
		And I click "Unlock linked rows" button
		And I go to line in "ItemList" table
			| 'Item'           | 'Item key'        |
			| 'Installation'   | 'Installation'    |
		And I select current line in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Assembly'       |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table does not contain lines
			| 'Item'           | 'Item key'        |
			| 'Installation'   | 'Installation'    |
		And I close all client application windows	

Scenario: _2065010 change quantity in the linked string in the SO (one session)
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '35'        |
		And I select current line in "List" table
	* Change quantity (less then SI)
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Procurement method'   | 'Quantity'    |
			| 'Shirt'   | '36/Red'     | 'No reserve'           | '10,000'      |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "9,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button	
		Then there are lines in TestClient message log
			| 'Line No. [3] [Shirt 36/Red] RowID movements remaining: 10 . Required: 9 . Lacking: 1 .'    |
	* Change quantity (more then SI)
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Procurement method'   | 'Quantity'    |
			| 'Shirt'   | '36/Red'     | 'No reserve'           | '9,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "11,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Sales orders" window is opened
		And I close all client application windows
		
				
Scenario: _2065011 change quantity in the linked string in the SI, SC after SI, SC exist (one session)
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '35'        |
		And I select current line in "List" table
	* Change quantity (less then SC, SC exist)
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'    |
			| 'Boots'   | '37/18SD'    | '2,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			| 'Line No. [1] [Boots 37/18SD] RowID movements remaining: 24 . Required: 12 . Lacking: 12 .'    |
	* Change quantity (more then SC, SC exist)
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'    |
			| 'Boots'   | '37/18SD'    | '1,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Sales invoices" window is opened
		And I close all client application windows

Scenario: _2065012 change quantity in the linked string in the SI, SI after SC, SC exist (one session)
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
		And I select current line in "List" table
	* Change quantity (more then SC, SC exist)
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'    |
			| 'Shirt'   | '36/Red'     | '10,000'      |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "11,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then there are lines in TestClient message log
			| 'In line 2 quantity by Shipment confirmation 36 dated 23.09.2021 10:20:59 11 greater than 10'    |
	* Change quantity (more then SC, SC exist)
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'    |
			| 'Shirt'   | '36/Red'     | '11,000'      |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "9,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Sales invoices" window is opened
		And I close all client application windows	
				
Scenario: _2065013 change quantity in the linked string in the SC, SC before SI (one session)
	* Open SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
		And I select current line in "List" table
	* Change quantity, unit (less then SI)
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'    |
			| 'Shirt'   | '36/Red'     | '10,000'      |
		And I select current line in "ItemList" table
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "8,000" text in "Quantity" field of "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			| 'Line No. [2] [Shirt 36/Red] RowID movements remaining: 9 . Required: 8 . Lacking: 1 .'    |
	* Change quantity (more then SI)
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'    |
			| 'Shirt'   | '36/Red'     | '8,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "11,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Shipment confirmations" window is opened
		And I close all client application windows
	
Scenario: _2065015 delete linked string in the SO (one session)
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '35'        |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Procurement method'    |
			| 'Shirt'   | '36/Red'     | 'No reserve'            |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click "Delete" button	
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Procurement method'    |
			| 'Shirt'   | '36/Red'     | 'No reserve'            |
		And Delay 3
		Then there are lines in TestClient message log
			| 'Can not delete linked row [3] [Shirt] [36/Red]'    |
		And I close all client application windows			

Scenario: _2065016 delete linked string in the SI (one session)
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '35'        |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'     |
			| 'Boots'    |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click "Delete" button	
		And "ItemList" table contains lines
			| 'Item'     |
			| 'Boots'    |
		And Delay 3
		Then there are lines in TestClient message log
			| 'Can not delete linked row [1] [Boots] [37/18SD]'    |
		And I close all client application windows

Scenario: _2065017 delete linked string in the SC (one session)
	And I close all client application windows
	* Open SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'     |
			| 'Dress'    |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And "ItemList" table contains lines
			| 'Item'     |
			| 'Dress'    |
		And Delay 3
		Then there are lines in TestClient message log
			| 'Can not delete linked row [1] [Dress] [XS/Blue]'    |
		And I close all client application windows

Scenario: _2065018 delete linked string in the WO (one session)
	* Open WO
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'           | 'Item key'        |
			| 'Installation'   | 'Installation'    |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click "Delete" button	
		And "ItemList" table contains lines
			| 'Item'           | 'Item key'        |
			| 'Installation'   | 'Installation'    |
		And Delay 3
		Then there are lines in TestClient message log
			| 'Can not delete linked row [1] [Installation] [Installation]'    |
		And I close all client application windows

Scenario: _20650181 delete linked string in the WS (one session)
		And I close all client application windows
	* Open WS
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'           | 'Item key'        |
			| 'Installation'   | 'Installation'    |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click "Delete" button	
		And "ItemList" table contains lines
			| 'Item'           | 'Item key'        |
			| 'Installation'   | 'Installation'    |
		And Delay 3
		Then there are lines in TestClient message log
			| 'Can not delete linked row [1] [Installation] [Installation]'    |
		And I close all client application windows


Scenario: _2065019 unpost SO with linked strings (one session)
	And I close all client application windows
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '35'        |
	* Try unpost SO
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Dress XS/Blue] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'       |
			| 'Line No. [3] [Shirt 36/Red] RowID movements remaining: 11 . Required: 0 . Lacking: 11 .'      |
			| 'Line No. [4] [Boots 37/18SD] RowID movements remaining: 24 . Required: 0 . Lacking: 24 .'     |
			| 'Line No. [5] [Service Internet] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'    |
		And I close all client application windows

Scenario: _2065020 unpost SI with linked strings (one session)
	And I close all client application windows
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '35'        |
	* Try unpost SI
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Boots 37/18SD] RowID movements remaining: 24 . Required: 0 . Lacking: 24 .'    |
	And I close all client application windows
	
Scenario: _2065021 unpost SC with linked strings (one session)
	And I close all client application windows
	* Select SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
	* Try unpost SC
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Dress XS/Blue] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'    |
			| 'Line No. [2] [Shirt 36/Red] RowID movements remaining: 9 . Required: 0 . Lacking: 9 .'     |
	And I close all client application windows		

Scenario: _2065022 unpost WS with linked strings (one session)
	And I close all client application windows
	* Select WS
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Try unpost WS
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Installation Installation] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'    |
			| 'Line No. [2] [Assembly Assembly] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'            |
		And I close all client application windows	

Scenario: _20650221 unpost WS with linked strings (one session)
	And I close all client application windows
	* Select WO
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
	* Try unpost WS
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Installation Installation] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'    |
			| 'Line No. [2] [Assembly Assembly] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'            |
		And I close all client application windows		

Scenario: _2065023 delete SO with linked strings (one session)
	And I close all client application windows
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '35'        |
	* Try delete SO
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Dress XS/Blue] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'       |
			| 'Line No. [3] [Shirt 36/Red] RowID movements remaining: 11 . Required: 0 . Lacking: 11 .'      |
			| 'Line No. [4] [Boots 37/18SD] RowID movements remaining: 24 . Required: 0 . Lacking: 24 .'     |
			| 'Line No. [5] [Service Internet] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'    |
		And I close all client application windows

Scenario: _2065024 delete SI with linked strings (one session)
	And I close all client application windows
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '35'        |
	* Try delete SI
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Boots 37/18SD] RowID movements remaining: 24 . Required: 0 . Lacking: 24 .'    |
	And I close all client application windows
	
Scenario: _2065025 delete SC with linked strings (one session)
	And I close all client application windows
	* Select SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
	* Try delete SC
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Dress XS/Blue] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'    |
			| 'Line No. [2] [Shirt 36/Red] RowID movements remaining: 9 . Required: 0 . Lacking: 9 .'     |
	And I close all client application windows

Scenario: _2065026 delete WO with linked strings (one session)
	And I close all client application windows
	* Select WO
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
	* Try delete WO
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Installation Installation] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'    |
			| 'Line No. [2] [Assembly Assembly] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'            |
		And I close all client application windows

Scenario: _2065027 delete WS with linked strings (one session)
	And I close all client application windows
	* Select WS
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Try delete WS
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Installation Installation] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'    |
			| 'Line No. [2] [Assembly Assembly] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'            |
		And I close all client application windows
				

Scenario: _2065029 check locking header in the SRO with linked documents (one session)
	And I close all client application windows
	* Open SRO
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
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


Scenario: _20650291 check unlock linked rows in the SRO
	And I close all client application windows
	* Open SRO
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
		And I select current line in "List" table
	* Check unlock linked rows
		And I click "Unlock linked rows" button
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'   | 'Item'     |
			| '38/Black'   | 'Shirt'    |
		And I close all client application windows	

Scenario: _2065030 check locking header in the SR with linked documents (one session)
	And I close all client application windows
	* Open SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
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

Scenario: _2065031 check unlock linked rows in the SR
	And I close all client application windows
	* Open SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
		And I select current line in "List" table
	* Check unlock linked rows
		And I click "Unlock linked rows" button
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'   | 'Item'     |
			| '38/Black'   | 'Shirt'    |
		And I close all client application windows

Scenario: _2065031 check locking tab in the SRO with linked documents (one session)
	And I close all client application windows
	* Open SRO
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
		And I select current line in "List" table
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Item" attribute in "ItemList" table
			And I close current window
		* Item key
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
		* Store
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Store" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Store" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Store" attribute in "ItemList" table
			And I close current window
		* Cancel
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
// 			When I Check the steps for Exception
//				|'And I set "Cancel" checkbox in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
//			When I Check the steps for Exception
//				|'And I set "Cancel" checkbox in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I set "Cancel" checkbox in "ItemList" table
			And I finish line editing
		* Cancel reason
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Cancel reason" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Cancel reason" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Cancel reason" attribute in "ItemList" table
			And I close "Cancel/Return reasons" window
		And I close all client application windows
	


Scenario: _2065032 check locking tab in the SR with linked documents (one session)
	And I close all client application windows
	* Open SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
		And I select current line in "List" table		
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Item" attribute in "ItemList" table
			And I close current window
		* Item key
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
		* Store
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Store" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Store" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Store" attribute in "ItemList" table
			And I close current window
		* Use SC
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			// When I Check the steps for Exception
			// 	|'And I remove "Use shipment confirmation" checkbox in "ItemList" table'|			
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			// When I Check the steps for Exception
			// 	|'And I remove "Use shipment confirmation" checkbox in "ItemList" table'|
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I set "Use goods receipt" checkbox in "ItemList" table
			And I finish line editing
		* Quantity
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			And I activate "Quantity" field in "ItemList" table
			And I input "30,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				| 'Line No. [2] [Boots 37/18SD] Return remaining: 24 . Required: 30 . Lacking: 6 .'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table			
		* Sales invoice
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Sales invoice" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Sales invoice" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Sales invoice" attribute in "ItemList" table
			And I close current window
		* Sales return order
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Sales return order" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Sales return order" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I click choice button of "Sales return order" attribute in "ItemList" table
			And I close current window
		And I close all client application windows
	

Scenario: _2065033 unpost SRO with linked strings (one session)
	And I close all client application windows
	* Select SRO
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
	* Try unpost SRO
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Shirt 36/Red] RowID movements remaining: 6 . Required: 0 . Lacking: 6 .'     |
			| 'Line No. [2] [Boots 37/18SD] RowID movements remaining: 4 . Required: 0 . Lacking: 4 .'    |
	And I close all client application windows
	
Scenario: _2065034 unpost SR with linked strings (one session)
	And I close all client application windows
	* Select SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
	* Try unpost SRO
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Shirt 36/Red] RowID movements remaining: 6 . Required: 0 . Lacking: 6 .'    |
	And I close all client application windows		
				

Scenario: _2065035 delete SRO with linked strings (one session)
	And I close all client application windows
	* Select SRO
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
	* Try delete SRO
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Shirt 36/Red] RowID movements remaining: 6 . Required: 0 . Lacking: 6 .'     |
			| 'Line No. [2] [Boots 37/18SD] RowID movements remaining: 4 . Required: 0 . Lacking: 4 .'    |
		And I close all client application windows

Scenario: _2065036 delete SR with linked strings (one session)
	And I close all client application windows
	* Select SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
	* Try delete SR
		And I activate field named "Date" in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check message
		Then there are lines in TestClient message log
			| 'Line No. [1] [Shirt 36/Red] RowID movements remaining: 6 . Required: 0 . Lacking: 6 .'    |
	And I close all client application windows		

Scenario: _2065037 delete linked string in the SRO (one session)
	And I close all client application windows
	* Open SRO
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'     |
			| 'Shirt'    |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And "ItemList" table contains lines
			| 'Item'     |
			| 'Shirt'    |
		And Delay 3
		Then there are lines in TestClient message log
			| 'Can not delete linked row [1] [Shirt] [36/Red]'    |
		And I close all client application windows		
			
Scenario: _2065038 delete linked string in the SR (one session)
	And I close all client application windows
	* Open SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
		And I select current line in "List" table
	* Delete linked string
		And I go to line in "ItemList" table
			| 'Item'     |
			| 'Shirt'    |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And "ItemList" table contains lines
			| 'Item'     |
			| 'Shirt'    |
		And Delay 3
		Then there are lines in TestClient message log
			| 'Can not delete linked row [1] [Shirt] [36/Red]'    |
		And I close all client application windows	

Scenario: _2065039 change quantity in the linked string in the SRO (one session)
	And I close all client application windows	
	* Open SRO
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
		And I select current line in "List" table
	* Change quantity, unit (less then SR)
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "ItemList" table
		And I activate "Quantity" field in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			| 'Line No. [1] [Shirt 36/Red] RowID movements remaining: 6 . Required: 5 . Lacking: 1 .'    |
	* Change quantity (more then SR)
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Sales return orders" window is opened
		And I close all client application windows

Scenario: _2065040 change quantity in the linked string in the SR (one session)
	And I close all client application windows	
	* Open SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
		And I select current line in "List" table
	* Change quantity, unit (less then GR)
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "ItemList" table
		And I activate "Quantity" field in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I input "50,000" text in "Landed cost" field of "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			| 'Line No. [1] [Shirt 36/Red] RowID movements remaining: 6 . Required: 5 . Lacking: 1 .'    |
	* Change quantity (more then GR)
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		Then user message window does not contain messages
		Then "Sales returns" window is opened
		And I close all client application windows

Scenario: _2065050 check locking header in the Planned receipt reservation with linked documents (one session)
	And I close all client application windows
	* Open PRR
		Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
		And I select current line in "List" table
	* Check locking header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And "Company" attribute is read-only
		And "Requester" attribute is read-only
		And "Branch" attribute is read-only
	And I close all client application windows


Scenario: _2065051 check locking tab in the Planned receipt reservation with linked documents (one session)
	And I close all client application windows
	* Open Planned receipt reservation
		Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
		And I select current line in "List" table		
	* Check locking tab
		* Items
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
		* Item key
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
		* Store
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Store (requester)" attribute in "ItemList" table'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '36/Red'       |
			When I Check the steps for Exception
				| 'And I click choice button of "Store (requester)" attribute in "ItemList" table'     |
		And I close all client application windows	

Scenario: _2065052 check unlock linked rows in the Planned receipt reservation
	And I close all client application windows
	* Open Planned receipt reservation
		Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
		And I select current line in "List" table
	* Check unlock linked rows
		And I click "Unlock linked rows" button
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'   | 'Item'     |
			| '38/Black'   | 'Shirt'    |
		And I close all client application windows


Scenario: _2065071 open link info
	And I close all client application windows	
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '35'        |
		And I select current line in "List" table		
	* Open link info
		And I activate "Is external linked" field in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'     |
			| 'Dress'    |
		And I select current line in "ItemList" table
		And "BasisesTree" table became equal
			| 'Row presentation'                                     | 'Quantity'   | 'Unit'   | 'Price'    | 'Currency'    |
			| 'Dress (XS/Blue)'                                      | '1,000'      | 'pcs'    | '520,00'   | 'TRY'         |
			| 'Shipment confirmation 36 dated 23.09.2021 10:20:59'   | ''           | ''       | ''         | ''            |
			| 'Sales invoice 36 dated 23.09.2021 10:21:37'           | ''           | ''       | ''         | ''            |
		And I close all client application windows
		

Scenario: _2065073 try unlink all rows in the SC (SO-SC-SI)
	And I close all client application windows	
	* Select SС
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '36'        |
		And I select current line in "List" table	
	* Try unlink all rows
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I set checkbox "Linked documents"
		And I expand a line in "ResultsTree" table
			| 'Row presentation'                            |
			| 'Sales order 35 dated 23.09.2021 10:19:43'    |
		And I activate field named "ResultsTreeRowPresentation" in "ResultsTree" table
		And I expand a line in "ResultsTree" table
			| 'Row presentation'                              |
			| 'Sales invoice 35 dated 23.09.2021 10:20:04'    |
		And in the table "ResultsTree" I click "Unlink all" button
	* Check
		And "ResultsTree" table became equal
			| 'Row presentation'                           | 'Quantity'   | 'Unit'   | 'Price'    | 'Currency'    |
			| 'Sales order 35 dated 23.09.2021 10:19:43'   | ''           | ''       | ''         | ''            |
			| 'Dress (XS/Blue)'                            | '1,000'      | 'pcs'    | '520,00'   | 'TRY'         |
			| 'Shirt (36/Red)'                             | '11,000'     | 'pcs'    | '350,00'   | 'TRY'         |
	And I close all client application windows
		
		
				
		
						
		
				

	
				

