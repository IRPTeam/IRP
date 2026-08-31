#language: en

@tree
@Positive
@LinkedTransaction


Functionality: locking linked strings several sessions (SO,SI,SC,SRO,SR, Planned receipt reservetion)

Variables:
import "Variables.feature"

Scenario: _2070001 preparation (locking linked strings)
	When set True value to the constant
	When set False value to the constant DisableLinkedRowsIntegrity
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
		When Create information register Taxes records (VAT)
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
	When Create Item with SerialLotNumbers (Phone)
	* Document Discount 
		When Create Document discount (for row)
		* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	When create SO,SI,SC,SRO,SR, Planned receipt reservetion for check locking linked strings several sessions
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(1055).GetObject().Write(DocumentWriteMode.Posting);"   |

Scenario: _20700011 check preparation
	When check preparation	

Scenario: _2070002 check locking header in the SO with linked documents (several sessions)
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '1 055'     |
		And I select current line in "List" table
	* Post SI
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1055).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Try change SO header
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I click "OK" button
		And I select "Second Company" exact value from the drop-down list named "Company"
		And I activate field named "ItemListLineNumber" in "ItemList" table
	* Check locking
		And I click "Save" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			| 'Wrong linked data [Company] used value [Main Company] wrong value [Second Company]'                 |
			| 'Wrong linked data [PartnerSales] used value [Ferron BP] wrong value [Kalipso]'                      |
			| 'Wrong linked data [LegalNameSales] used value [Company Ferron BP] wrong value [Company Kalipso]'    |
			| 'Wrong linked row [1] for column [Store] used value [Store 02] wrong value [Store 03]'               |
		And I close all client application windows

Scenario: _2070003 check locking item tab in the SO with linked documents (several sessions)
	And I close all client application windows
	* Unpost SI
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1055).GetObject().Write(DocumentWriteMode.UndoPosting);"    |
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '1 055'     |
		And I select current line in "List" table
	* Post SC
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1055).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Change item key, store, procurement method
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '3'   | 'Shirt'   | '36/Red'     | '11,000'      |
		And I select current line in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Code'   | 'Item'    | 'Item key'    |
			| '13'     | 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListStore" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListStore" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Check locking
		And I click "Save" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			| 'Wrong linked row [3] for column [ItemKey] used value [36/Red] wrong value [38/Black]'               |
			| 'Wrong linked row [3] for column [Store] used value [Store 02] wrong value [Store 03]'               |
			| 'Wrong linked row [3] for column [ProcurementMethod] used value [No reserve] wrong value [Stock]'    |
	* Change item key, store, procurement method back
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '3'   | 'Shirt'   | '38/Black'   | '11,000'      |
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Code'   | 'Item'    | 'Item key'    |
			| '12'     | 'Shirt'   | '36/Red'      |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "No reserve" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Store" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Store" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Store 02'      |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Cancel line and check locking
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '3'   | 'Shirt'   | '36/Red'     | '11,000'      |
		And I select current line in "ItemList" table
		And I activate "Cancel" field in "ItemList" table
		And I set "Cancel" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Save" button
		Then there are lines in TestClient message log
			| 'Cancel reason has to be filled if string was canceled'    |
		And I close all client application windows
		

Scenario: _2070004 change quantity in the linked string in the SO (several sessions)
	And I close all client application windows
	* Unpost SI
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1055).GetObject().Write(DocumentWriteMode.UndoPosting);"    |
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '1 055'     |
		And I select current line in "List" table
	* Post SI
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1055).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Try to change quantity (less then SI)
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'    |
			| 'Boots'   | '37/18SD'    | '2,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			| 'Line No. [4] [Boots 37/18SD] RowID movements remaining: 24 . Required: 12 . Lacking: 12 .'    |
	And I close all client application windows
	
Scenario: _2070005 delete linked string in the SO (several sessions)
	And I close all client application windows
	* Unpost SI
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1055).GetObject().Write(DocumentWriteMode.UndoPosting);"    |
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '1 055'     |
		And I select current line in "List" table
	* Post SI
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1055).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Try to change quantity (less then SI)
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Dress'   | 'XS/Blue'    | '1,000'       |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click "Delete" button	
		And I click "Save" button
		And I click "OK" button
		Then there are lines in TestClient message log
			| 'Line No. [] [ ] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'    |
	And I close all client application windows	
				
Scenario: _2070006 unpost SO with linked strings (several sessions)
	And I close all client application windows
	* Unpost SI
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1055).GetObject().Write(DocumentWriteMode.UndoPosting);"    |
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '1 055'     |
		And I select current line in "List" table
	* Post Planned receipt reservation
		And I execute 1C:Enterprise script at server
			| "Documents.PlannedReceiptReservation.FindByNumber(1055).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Try unpost SO
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			| 'Line No. [6] [Shirt 36/Red] RowID movements remaining: 10 . Required: 0 . Lacking: 10 .'    |
	And I close all client application windows	
				
Scenario: _2070007 delete SO with linked strings (several sessions)
	And I close all client application windows
	* Unpost SI
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1055).GetObject().Write(DocumentWriteMode.UndoPosting);"    |
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '1 055'     |
		And I select current line in "List" table
	* Post SI
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1055).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Try unpost SO
		And I click the button named "FormSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button	
		Then there are lines in TestClient message log
			| 'Line No. [1] [Dress XS/Blue] RowID movements remaining: 1 . Required: 0 . Lacking: 1 .'      |
			| 'Line No. [4] [Boots 37/18SD] RowID movements remaining: 24 . Required: 0 . Lacking: 24 .'    |
	And I close all client application windows	
	


# Concurrent quota smoke: two Sales invoices generated from the SAME order in two
# windows. The second one is posted first and takes the whole quota; posting the
# first one afterwards must be blocked by the RowID quota control - the quota can
# never be consumed twice.
Scenario: _2070008 two invoices racing for the same order quota: the late post is blocked (concurrent smoke)
	And I close all client application windows
	* Create and post SO_LT2070_08 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2070-08" text in the field named "Text"
		And I click "OK" button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
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
		And I activate field named "ItemListStore" in "ItemList" table
		And I click choice button of the attribute named "ItemListStore" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2070_08_SO$$" variable
		And I save the window as "$$LT2070_08_SO$$"
	* First Sales invoice: generated and left UNPOSTED (it holds no quota yet)
		And I click "Sales invoice" button
		And I click "Ok" button
		And I delete "$$LT2070_08_SI1$$" variable
		And I save the window as "$$LT2070_08_SI1$$"
	* Second Sales invoice: generated from the same order and posted FIRST (takes the whole quota)
		When in opened panel I select "$$LT2070_08_SO$$"
		And I click "Sales invoice" button
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Posting the first invoice is blocked: its linked basis row is already fully
	* consumed by the second invoice (the linked-rows integrity check refuses it)
		When in opened panel I select "$$LT2070_08_SI1$$"
		And I click the button named "FormPost"
		Then there are lines in TestClient message log
			| 'Wrong linked row [1] [Dress] [XS/Blue]' |
		And I close all client application windows
