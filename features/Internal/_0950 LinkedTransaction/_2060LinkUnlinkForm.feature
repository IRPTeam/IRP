#language: en
@tree
@Positive
@LinkedTransaction

Feature: link unlink form

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _2060001 preparation
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
		When Create catalog Countries objects
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create Document discount
		* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers, single row)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create information register Taxes records (VAT)
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
	When Create Item with SerialLotNumbers (Phone)
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When Create document Purchase order objects (with SerialLotNumber)
	When Create document PurchaseInvoice objects (linked)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.PurchaseInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Write);"   |
		| "Documents.PurchaseInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);" |
	* Save PI numbers
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '101' |
		And I select current line in "List" table	
		And I delete "$$PurchaseInvoice2040005$$" variable
		And I delete "$$NumberPurchaseInvoice2040005$$" variable
		And I save the window as "$$PurchaseInvoice2040005$$"
		And I save the value of "Number" field as "$$NumberPurchaseInvoice2040005$$"
		And I close current window
		And I go to line in "List" table
			| 'Number'    |
			| '102' |
		And I select current line in "List" table	
		And I delete "$$PurchaseInvoice20400051$$" variable
		And I delete "$$NumberPurchaseInvoice20400051$$" variable
		And I save the window as "$$PurchaseInvoice20400051$$"
		And I save the value of "Number" field as "$$NumberPurchaseInvoice20400051$$"
		And I close all client application windows
	When Create document SalesInvoice objects (linked)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Write);"   |
			| "Documents.SalesInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Write);"   |
			| "Documents.SalesInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(103).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.SalesInvoice.FindByNumber(103).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create document SalesOrder objects (SI before SC, not Use shipment sheduling)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(31).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.SalesOrder.FindByNumber(31).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Write);"   |
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
	When create Sales invoice and Sales order object (sln, autolink)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2054).GetObject().Write(DocumentWriteMode.Write);"   |
			| "Documents.SalesInvoice.FindByNumber(2054).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(2054).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.SalesOrder.FindByNumber(2054).GetObject().Write(DocumentWriteMode.Posting);" |
	When create Inventory transfer and Inventory transfer object (sln, autolink)
	And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransferOrder.FindByNumber(2054).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.InventoryTransferOrder.FindByNumber(2054).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransfer.FindByNumber(2054).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.InventoryTransfer.FindByNumber(2054).GetObject().Write(DocumentWriteMode.Posting);" |
	When create SalesOrder and ShipmentConfirmation object (sln, autolink)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(2055).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.SalesOrder.FindByNumber(2055).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(2054).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.ShipmentConfirmation.FindByNumber(2054).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(2055).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.ShipmentConfirmation.FindByNumber(2055).GetObject().Write(DocumentWriteMode.Posting);" |
	* Save SI numbers
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '101' |
		And I select current line in "List" table	
		And I delete "$$SalesInvoice20400022$$" variable
		And I delete "$$NumberSalesInvoice20400022$$" variable
		And I save the window as "$$SalesInvoice20400022$$"
		And I save the value of "Number" field as "$$NumberSalesInvoice20400022$$"
		And I close current window
		And I go to line in "List" table
			| 'Number'    |
			| '102' |
		And I select current line in "List" table	
		And I delete "$$SalesInvoice2040002$$" variable
		And I delete "$$NumberSalesInvoice2040002$$" variable
		And I save the window as "$$SalesInvoice2040002$$"
		And I save the value of "Number" field as "$$NumberSalesInvoice2040002$$"
		And I close current window
		And I go to line in "List" table
			| 'Number'    |
			| '103' |
		And I select current line in "List" table	
		And I delete "$$SalesInvoice20400021$$" variable
		And I delete "$$NumberSalesInvoice20400021$$" variable
		And I save the window as "$$SalesInvoice20400021$$"
		And I save the value of "Number" field as "$$NumberSalesInvoice20400021$$"
		And I close all client application windows
	When Create catalog PaymentTypes objects
	When Create catalog RetailCustomers objects (check POS)
	When create GoodsReceipt and PurchaseOrder objects (select from basis in the PI)
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(1051).GetObject().Write(DocumentWriteMode.Write);"|
			| "Documents.PurchaseOrder.FindByNumber(1051).GetObject().Write(DocumentWriteMode.Posting);"|
	And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1051).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.GoodsReceipt.FindByNumber(1051).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1052).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.GoodsReceipt.FindByNumber(1052).GetObject().Write(DocumentWriteMode.Posting);" |
	When create ShipmentConfirmation and SalesOrder objects (select from basis in the PI)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1051).GetObject().Write(DocumentWriteMode.Write);"|
			| "Documents.SalesOrder.FindByNumber(1051).GetObject().Write(DocumentWriteMode.Posting);"|
	And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1051).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.ShipmentConfirmation.FindByNumber(1051).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1052).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.ShipmentConfirmation.FindByNumber(1052).GetObject().Write(DocumentWriteMode.Posting);" |
	And Delay 5
	When Create SO and SC for link
	And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1053).GetObject().Write(DocumentWriteMode.Write);"|
			| "Documents.SalesOrder.FindByNumber(1053).GetObject().Write(DocumentWriteMode.Posting);"|
	And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1052).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.SalesOrder.FindByNumber(1052).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1053).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.ShipmentConfirmation.FindByNumber(1053).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create document RetailSalesReceipt objects (with retail customer)
	And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Write);"|
			| "Documents.RetailSalesReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);"|
	When Create PO and GR for link
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(1052).GetObject().Write(DocumentWriteMode.Write);"|
			| "Documents.PurchaseOrder.FindByNumber(1052).GetObject().Write(DocumentWriteMode.Posting);"|
	And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1053).GetObject().Write(DocumentWriteMode.Write);" |	
			| "Documents.GoodsReceipt.FindByNumber(1053).GetObject().Write(DocumentWriteMode.Posting);" |	
	When Create Physical inventory and Stock adjustment as write-off for link
	And I execute 1C:Enterprise script at server
			| "Documents.PhysicalInventory.FindByNumber(152).GetObject().Write(DocumentWriteMode.Write);"|
			| "Documents.PhysicalInventory.FindByNumber(152).GetObject().Write(DocumentWriteMode.Posting);"|
	And I execute 1C:Enterprise script at server
			| "Documents.StockAdjustmentAsWriteOff.FindByNumber(152).GetObject().Write(DocumentWriteMode.Write);" |
			| "Documents.StockAdjustmentAsWriteOff.FindByNumber(152).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create catalog CancelReturnReasons objects

		
Scenario: _20600011 check preparation
	When check preparation
			
	
Scenario: _2060002 check link/unlink form in the SC
		And I close all client application windows
	* Open form for create SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 01  |
		And I select current line in "List" table
		And I select "Sales" exact value from "Transaction type" drop-down list
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Adel'     |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table		
	* Select items from basis documents
		And in the table "ItemList" I click "Add basis documents" button
		And I expand current line in "BasisesTree" table
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                            | 'Use'                                         |
			| 'Sales invoice 102 dated 05.03.2021 12:57:59' | 'No' |
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                            | 'Use'                                         |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' | 'No' |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '700,00' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '440,68' | '8,000'    | 'Dress (M/White)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '648,15' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Show row key" button
		And I click "Ok" button
		And I click "Show row key" button
	* Check RowIDInfo
		And "RowIDInfo" table contains lines
		| '#' | 'Basis'                                       | 'Next step' | 'Quantity'     | 'Current step' |
		| '1' | 'Sales invoice 103 dated 05.03.2021 12:59:44' | ''          | '8,000' | 'SC'           |
		| '2' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''          | '2,000' | 'SC'           |
		| '3' | 'Sales invoice 103 dated 05.03.2021 12:59:44' | ''          | '2,000' | 'SC'           |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Unlink line
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I set checkbox "Linked documents"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '3' | '2,000'    | 'Boots (37/18SD)'   | 'Store 02' | 'pcs'  |
		And I expand a line in "ResultsTree" table
			| 'Row presentation'                            |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "ResultsTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '648,15' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  |
		And I click "Unlink" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Sales invoice'                               |
			| 'Dress' | 'M/White'  | 'Sales invoice 103 dated 05.03.2021 12:59:44' |
			| 'Boots' | '37/18SD'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' |
			| 'Boots' | '37/18SD'  | ''                                            |
	* Link line
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '3' | '2,000'    | 'Boots (37/18SD)'   | 'Store 02' | 'pcs'  |
		And I set checkbox "Linked documents"
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                            |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '648,15' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  |
		And I click "Link" button
		And I click "Ok" button
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                       | 'Next step' | 'Quantity'     | 'Current step' |
			| '1' | 'Sales invoice 103 dated 05.03.2021 12:59:44' | ''          | '8,000' | 'SC'           |
			| '2' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''          | '2,000' | 'SC'           |
			| '3' | 'Sales invoice 103 dated 05.03.2021 12:59:44' | ''          | '2,000' | 'SC'           |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Sales invoice'                               |
			| 'Dress' | 'M/White'  | 'Sales invoice 103 dated 05.03.2021 12:59:44' |
			| 'Boots' | '37/18SD'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' |
			| 'Boots' | '37/18SD'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' |
	* Delete string, add it again, change unit
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity' | 'Store'    |
			| 'Boots' | '37/18SD'  | '2,000'    | 'Store 02' |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And in the table "ItemList" I click "Add basis documents" button
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '648,15' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Sales invoice'                               |
			| 'Dress' | 'M/White'  | 'Sales invoice 103 dated 05.03.2021 12:59:44' |
			| 'Boots' | '37/18SD'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' |
			| 'Boots' | '37/18SD'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' |
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity' | 'Store'    |
			| 'Boots' | '37/18SD'  | '2,000'    | 'Store 02' |
		And I activate "Unit" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots (12 pcs)' |
		And I select current line in "List" table
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                       | 'Next step' | 'Quantity'     | 'Current step' |
			| '1' | 'Sales invoice 103 dated 05.03.2021 12:59:44' | ''          | '8,000' | 'SC'           |
			| '2' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''          | '2,000' | 'SC'           |
			| '3' | 'Sales invoice 103 dated 05.03.2021 12:59:44' | ''          | '24,000' | 'SC'          |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Add all items from SI
		And in the table "ItemList" I click "Add basis documents" button
		And I go to line in "BasisesTree" table
			| 'Row presentation'                            | 'Use' |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Store'    | 'Item'  | 'Item key' | 'Quantity' | 'Sales invoice'                               | 'Unit'           |
			| 'Store 02' | 'Dress' | 'M/White'  | '8,000'    | 'Sales invoice 103 dated 05.03.2021 12:59:44' | 'pcs'            |
			| 'Store 01' | 'Boots' | '37/18SD'  | '2,000'    | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'pcs'            |
			| 'Store 02' | 'Boots' | '37/18SD'  | '2,000'    | 'Sales invoice 103 dated 05.03.2021 12:59:44' | 'Boots (12 pcs)' |
			| 'Store 02' | 'Boots' | '36/18SD'  | '2,000'    | 'Sales invoice 103 dated 05.03.2021 12:59:44' | 'Boots (12 pcs)' |
			| 'Store 02' | 'Dress' | 'S/Yellow' | '8,000'    | 'Sales invoice 103 dated 05.03.2021 12:59:44' | 'pcs'            |
	* Unlink all lines
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I set checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And "BasisesTree" table became equal
			| 'Row presentation'                            | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' | ''         | ''     | ''       | ''         |
			| 'Dress (M/White)'                             | '8,000'    | 'pcs'  | '440,68' | 'TRY'      |
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Store'    | 'Item'  | 'Item key' | 'Quantity' | 'Sales invoice' | 'Unit'           |
			| 'Store 02' | 'Dress' | 'M/White'  | '8,000'    | ''              | 'pcs'            |
			| 'Store 01' | 'Boots' | '37/18SD'  | '2,000'    | ''              | 'pcs'            |
			| 'Store 02' | 'Boots' | '37/18SD'  | '2,000'    | ''              | 'Boots (12 pcs)' |
			| 'Store 02' | 'Boots' | '36/18SD'  | '2,000'    | ''              | 'Boots (12 pcs)' |
			| 'Store 02' | 'Dress' | 'S/Yellow' | '8,000'    | ''              | 'pcs'            |
	* Check use reserve basis tree
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I set checkbox "Use reverse basises tree"
		And I expand current line in "BasisesTreeReverse" table
		And "BasisesTreeReverse" table became equal
			| 'Row presentation'                            | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Dress (M/White)'                             | ''         | 'pcs'  | ''       | ''         |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' | '8,000'    | 'pcs'  | '440,68' | 'TRY'      |
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '2,000'    | 'Boots (37/18SD)'  | 'Store 01' | 'pcs'  |
		And I expand a line in "BasisesTreeReverse" table
			| 'Row presentation' | 'Unit' |
			| 'Boots (37/18SD)'  | 'pcs'  |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And "BasisesTreeReverse" table became equal
			| 'Row presentation'                            | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Boots (37/18SD)'                             | ''         | 'pcs'  | ''       | ''         |
			| 'Sales invoice 101 dated 05.03.2021 12:56:38' | '2,000'    | 'pcs'  | '700,00' | 'TRY'      |
			| 'Sales invoice 102 dated 05.03.2021 12:57:59' | '1,000'    | 'pcs'  | '700,00' | 'TRY'      |										
		And I close all client application windows
		
		
Scenario: _2060003 check auto link button in the SI
	* Open form for create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
	* Add items	
		* One SO - 1 pcs, second SO - 1 pcs
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
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
		* One SO - 10 pcs, second SO - 10 pcs
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
		* One SO - 1 pcs, second SO - 1 pcs
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Service'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'    | 'Item key' |
				| 'Service' | 'Internet' |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
		* More than in SO, only one line
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD' |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "65,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
	* Auto link
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I click "Auto link" button
		And I click "Ok" button
	* Check auto link
		And "ItemList" table contains lines
			| '#' | 'Revenue type' | 'Price type'              | 'Item'    | 'Item key' | 'Profit loss center'      | 'Dont calculate row' | 'Serial lot numbers' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'    | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order'                             |
			| '1' | 'Revenue'      | 'Basic Price Types'       | 'Dress'   | 'XS/Blue'  | 'Distribution department' | 'No'                 | ''                   | '2,000'    | 'pcs'  | '150,72'     | '520,00'   | '18%' | '52,00'         | '837,28'     | '988,00'       | ''                    | 'Store 02' | '27.01.2021'    | 'Yes'                       | ''       | 'Sales order 3 dated 27.01.2021 19:50:45' |
			| '2' | 'Revenue'      | 'Basic Price Types'       | 'Shirt'   | '36/Red'   | 'Distribution department' | 'No'                 | ''                   | '10,000'   | 'pcs'  | '507,20'     | '350,00'   | '18%' | '175,00'        | '2 817,80'   | '3 325,00'     | ''                    | 'Store 02' | '27.01.2021'    | 'Yes'                       | ''       | 'Sales order 3 dated 27.01.2021 19:50:45' |
			| '3' | 'Revenue'      | 'en description is empty' | 'Service' | 'Internet' | 'Front office'            | 'No'                 | ''                   | '1,000'    | 'pcs'  | '14,49'      | '100,00'   | '18%' | '5,00'          | '80,51'      | '95,00'        | ''                    | 'Store 02' | '27.01.2021'    | 'No'                        | ''       | 'Sales order 3 dated 27.01.2021 19:50:45' |
			| '4' | 'Revenue'      | 'Basic Price Types'       | 'Boots'   | '36/18SD'  | 'Front office'            | 'No'                 | ''                   | '65,000'   | 'pcs'  | '6 940,68'   | '8 400,00' | '18%' | ''              | '38 559,32'  | '45 500,00'    | ''                    | 'Store 02' | '27.01.2021'    | 'Yes'                       | ''       | 'Sales order 3 dated 27.01.2021 19:50:45' |
		Then the number of "ItemList" table lines is "равно" "4"
		And I close all client application windows


Scenario: _2060004 check button not calculate rows
	And I close all client application windows
	* Open form for create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Maxim'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Maxim'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	* Add items	
		* First item
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
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "3" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Second item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Product 7 with SLN (new row)'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'                         | 'Item key' |
				| 'Product 7 with SLN (new row)' | 'PZU'      |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "5" text in the field named "ItemListPrice" of "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And I click Choice button of the field named "SerialLotNumberSingle"
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'PZU'   | '9009099'       |
			And I select current line in "List" table
			And I click "Ok" button		
			And I finish line editing in "ItemList" table
			And "ItemList" table became equal
				| '#' | 'Price type'              | 'Item'                         | 'Item key' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price' | 'VAT' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Other revenue type'   | 'Store'    | 'Use shipment confirmation' |
				| '1' | 'en description is empty' | 'Dress'                        | 'XS/Blue'  | 'No'                 | '0,92'       | 'pcs'  | ''                   | '2,000'    | '3,00'  | '18%' | '5,08'       | '6,00'         | 'No'             | ''                     | 'Store 01' | 'No'                        |
				| '2' | 'en description is empty' | 'Product 7 with SLN (new row)' | 'PZU'      | 'No'                 | '0,76'       | 'pcs'  | '9009099'            | '1,000'    | '5,00'  | '18%' | '4,24'       | '5,00'         | 'No'             | ''                     | 'Store 01' | 'No'                        |
	* Check not calculate row
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I remove checkbox "Calculate rows"
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '520,00' | '2,000'    | 'Dress (XS/Blue)'  | 'pcs'  |
		And I click the button named "Link"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation'                             | 'Store'    | 'Unit' |
			| '2' | '1,000'    | 'Product 7 with SLN (new row) (PZU) (9009099)' | 'Store 01' | 'pcs'  |
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                            |
			| 'Sales order 2 054 dated 11.04.2023 15:25:22' |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'                   | 'Unit' |
			| 'TRY'      | '100,00' | '3,000'    | 'Product 7 with SLN (new row) (PZU)' | 'pcs'  |
		And I click the button named "Link"
		And I click "Ok" button
		And "ItemList" table became equal
				| '#' | 'Price type'              | 'Item'                         | 'Item key' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price' | 'VAT' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Other revenue type'   | 'Store'    | 'Use shipment confirmation' |
				| '1' | 'en description is empty' | 'Dress'                        | 'XS/Blue'  | 'No'                 | '0,92'       | 'pcs'  | ''                   | '2,000'    | '3,00'  | '18%' | '5,08'       | '6,00'         | 'No'             | ''                     | 'Store 01' | 'No'                        |
				| '2' | 'en description is empty' | 'Product 7 with SLN (new row)' | 'PZU'      | 'No'                 | '0,76'       | 'pcs'  | '9009099'            | '1,000'    | '5,00'  | '18%' | '4,24'       | '5,00'         | 'No'             | ''                     | 'Store 01' | 'No'                        |
	* Not calculate row (auto link)
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I set checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		Then the form attribute named "CalculateRows" became equal to "No"
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table became equal
				| '#' | 'Price type'              | 'Item'                         | 'Item key' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price' | 'VAT' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Other revenue type'   | 'Store'    | 'Use shipment confirmation' |
				| '1' | 'en description is empty' | 'Dress'                        | 'XS/Blue'  | 'No'                 | '0,92'       | 'pcs'  | ''                   | '2,000'    | '3,00'  | '18%' | '5,08'       | '6,00'         | 'No'             | ''                     | 'Store 01' | 'No'                        |
				| '2' | 'en description is empty' | 'Product 7 with SLN (new row)' | 'PZU'      | 'No'                 | '0,76'       | 'pcs'  | '9009099'            | '1,000'    | '5,00'  | '18%' | '4,24'       | '5,00'         | 'No'             | ''                     | 'Store 01' | 'No'                        |
		And I close all client application windows
					



Scenario: _20600031 check Link unlink basis documents form
		And I close all client application windows
	* Open form for create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
	* Add items	
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
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check Link unlink basis documents forms
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I set checkbox "Calculate rows"
		And "ItemListRows" table contains lines
			| 'Row presentation' |
			| 'Dress (XS/Blue)'  |
		And "BasisesTree" table became equal
			| 'Row presentation'                        | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 3 dated 27.01.2021 19:50:45' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                         | '1,000'    | 'pcs'  | '520,00' | 'TRY'      |	
		* Delete and F9
			And I go to line in "ItemListRows" table
				| 'Row presentation' |
				| 'Dress (XS/Blue)'  |
			And I go to line in "BasisesTree" table
				| 'Row presentation' |
				| 'Dress (XS/Blue)'  |			
			And I activate current test client window
			And I press keyboard shortcut "Delete"
			And "BasisesTree" table became equal
				| 'Row presentation'                        | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
				| 'Sales order 3 dated 27.01.2021 19:50:45' | ''         | ''     | ''       | ''         |
				| 'Dress (XS/Blue)'                         | '1,000'    | 'pcs'  | '520,00' | 'TRY'      |
			And I activate current test client window
			And I press keyboard shortcut "F9"
			And "BasisesTree" table became equal
				| 'Row presentation'                        | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
				| 'Sales order 3 dated 27.01.2021 19:50:45' | ''         | ''     | ''       | ''         |
				| 'Dress (XS/Blue)'                         | '1,000'    | 'pcs'  | '520,00' | 'TRY'      |
			And I go to line in "ItemListRows" table
				| 'Row presentation' |
				| 'Dress (XS/Blue)'  |
			And I activate current test client window
			And I press keyboard shortcut "Delete"
			And "ItemListRows" table contains lines
				| 'Row presentation' |
				| 'Dress (XS/Blue)'  |
			And I go to line in "ItemListRows" table
				| 'Row presentation' |
				| 'Dress (XS/Blue)'  |
			And I activate current test client window
			And I press keyboard shortcut "F9"
			And I wait that in "ItemListRows" table number of lines will be "equal" "1" for "10" seconds
		* Show row key
			And I click "Show row key" button
			Then the number of "ResultsTable" table lines is "равно" 0
			And I activate current test client window
			And I go to line in "BasisesTree" table
				| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
				| 'TRY'      | '520,00' | '1,000'    | 'Dress (XS/Blue)'  | 'pcs'  |
			And I activate current test client window
			And Delay 5
			And I select current line in "BasisesTree" table
			And "ResultsTable" table became equal
				| 'Item'  | 'Item key' | 'Store'    | 'Key' | 'Basis'                                   | 'Unit' | 'Basis unit' | 'Stock quantity' | 'Current step' | 'Row ref' | 'Parent basis' | 'Row ID' | 'Basis key' |
				| 'Dress' | 'XS/Blue'  | 'Store 02' | '*'   | 'Sales order 3 dated 27.01.2021 19:50:45' | 'pcs'  | 'pcs'        | '2,000'          | 'SI&SC'        | '*'       | ''             | '*'      | '*'         |
		* Delete Quantity and check Link unlink basis documents
			And I close "Link / unlink document row" window
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I select current line in "ItemList" table
			And I input "0,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click "Link unlink basis documents" button
			And "BasisesTree" table became equal
				| 'Row presentation'                        | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
				| 'Sales order 3 dated 27.01.2021 19:50:45' | ''         | ''     | ''       | ''         |
				| 'Dress (XS/Blue)'                         | '1,000'    | 'pcs'  | '520,00' | 'TRY'      |
			And I go to line in "BasisesTree" table
				| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
				| 'TRY'      | '520,00' | '1,000'    | 'Dress (XS/Blue)'  | 'pcs'  |
			And I click the button named "Link"
			And I click "Ok" button
			And "ItemList" table became equal
				| 'Item'  | 'Item key' | 'Quantity'     | 'Unit' | 'Price'  | 'Sales order'                             |
				| 'Dress' | 'XS/Blue'  | '1,000' | 'pcs'  | '520,00' | 'Sales order 3 dated 27.01.2021 19:50:45' |
		And I close all client application windows
		
		



Scenario: _2060004 check link/unlink form in the SRO
	* Open form for create SRO
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 01  |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Adel'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table		
	* Select items from basis documents
		And in the table "ItemList" I click "Add basis documents" button
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '700,00' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '4,000'    | 'Dress (M/White)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '700,00' | '1,000'    | 'Boots (37/18SD)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Show row key" button
		And in the table "ItemList" I click "Edit quantity in base unit" button	
		And I click "Post" button		
	* Check RowIDInfo
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                       | 'Next step' | 'Quantity'     | 'Current step' |
			| '1' | 'Sales invoice 102 dated 05.03.2021 12:57:59' | 'SR'        | '1,000' | 'SRO&SR'       |
			| '2' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'SR'        | '2,000' | 'SRO&SR'       |
			| '3' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'SR'        | '4,000' | 'SRO&SR'       |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Unlink line
		And in the table "ItemList" I click "Link unlink basis documents" button		
		Then "Link / unlink document row" window is opened
		And I set checkbox "Linked documents"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '2,000'    | 'Boots (37/18SD)'   | 'Store 01' | 'pcs'  |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "ResultsTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '700,00' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  |
		And I click "Unlink" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Quantity'     | 'Unit' | 'Sales invoice'                               | 'Item key' |
			| 'Boots' | '1,000' | 'pcs'  | 'Sales invoice 102 dated 05.03.2021 12:57:59' | '37/18SD'  |
			| 'Boots' | '2,000' | 'pcs'  | ''                                            | '37/18SD'  |
			| 'Dress' | '4,000' | 'pcs'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'M/White'  |	
	* Link line
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '2,000'    | 'Boots (37/18SD)'   | 'Store 01' | 'pcs'  |
		And I set checkbox "Linked documents"
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '700,00' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  |
		And I click "Link" button
		And I click "Ok" button
		And I click "Save" button
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                       | 'Next step' | 'Quantity'     | 'Current step' |
			| '1' | 'Sales invoice 102 dated 05.03.2021 12:57:59' | 'SR'        | '1,000' | 'SRO&SR'       |
			| '2' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'SR'        | '2,000' | 'SRO&SR'       |
			| '3' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'SR'        | '4,000' | 'SRO&SR'       |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And "ItemList" table contains lines
			| 'Item'  | 'Quantity'     | 'Unit' | 'Sales invoice'                               | 'Item key' |
			| 'Boots' | '1,000' | 'pcs'  | 'Sales invoice 102 dated 05.03.2021 12:57:59' | '37/18SD'  |
			| 'Boots' | '2,000' | 'pcs'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' | '37/18SD'  |
			| 'Dress' | '4,000' | 'pcs'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'M/White'  |
	* Delete string, add it again, change unit
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity' | 'Store'    |
			| 'Boots' | '37/18SD'  | '2,000'    | 'Store 01' |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And in the table "ItemList" I click "Add basis documents" button
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '700,00' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Quantity'     | 'Unit' | 'Sales invoice'                               | 'Item key' |
			| 'Boots' | '1,000' | 'pcs'  | 'Sales invoice 102 dated 05.03.2021 12:57:59' | '37/18SD'  |
			| 'Boots' | '2,000' | 'pcs'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' | '37/18SD'  |
			| 'Dress' | '4,000' | 'pcs'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'M/White'  |
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity'     | 'Store'    |
			| 'Boots' | '37/18SD'  | '2,000' | 'Store 01' |
		And I activate "Unit" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots (12 pcs)' |
		And I select current line in "List" table
		And I click "Save" button
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                       | 'Next step' | 'Quantity'     | 'Current step' |
			| '1' | 'Sales invoice 102 dated 05.03.2021 12:57:59' | 'SR'        | '1,000' | 'SRO&SR'       |
			| '2' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'SR'        | '4,000' | 'SRO&SR'       |
			| '3' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'SR'        | '24,000' | 'SRO&SR'       |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Unlink all lines
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I set checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I go to line in "ItemListRows" table
			| 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '1,000'    | 'Boots (37/18SD)'  | 'Store 01' | 'pcs'  |
		And "BasisesTree" table contains lines
			| 'Row presentation'                            | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''         | ''     | ''       | ''         |
			| 'Boots (37/18SD)'                             | '2,000'    | 'pcs'  | '700,00' | 'TRY'      |
			| 'Sales invoice 102 dated 05.03.2021 12:57:59' | ''         | ''     | ''       | ''         |
			| 'Boots (37/18SD)'                             | '1,000'    | 'pcs'  | '700,00' | 'TRY'      |		
		And I click "Ok" button
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Store'    | 'Stock quantity' | 'Item'  | 'Quantity' | 'Unit'           | 'Tax amount' | 'Price'    | 'VAT' | 'Net amount' | 'Total amount' | 'Sales invoice' | 'Revenue type' | 'Item key' | 'Cancel' | 'Cancel reason' |
			| 'Store 01' | '1,000'          | 'Boots' | '1,000'    | 'pcs'            | '106,78'     | '700,00'   | '18%' | '593,22'     | '700,00'       | ''              | 'Revenue'      | '37/18SD'  | 'No'     | ''              |
			| 'Store 01' | '4,000'          | 'Dress' | '4,000'    | 'pcs'            | '317,29'     | '520,00'   | '18%' | '1 762,71'   | '2 080,00'     | ''              | 'Revenue'      | 'M/White'  | 'No'     | ''              |
			| 'Store 01' | '24,000'         | 'Boots' | '2,000'    | 'Boots (12 pcs)' | '2 562,71'   | '8 400,00' | '18%' | '14 237,29'  | '16 800,00'    | ''              | 'Revenue'      | '37/18SD'  | 'No'     | ''              |
		Then the number of "ItemList" table lines is "равно" "3"					
		And I close all client application windows
		
Scenario: _2060005 check link/unlink form in the SR
	* Open form for create SR
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 01  |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Adel'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table		
	* Select items from basis documents
		And I click "Add basis documents" button
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '700,00' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '4,000'    | 'Dress (M/White)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '700,00' | '1,000'    | 'Boots (37/18SD)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Show row key" button
		And in the table "ItemList" I click "Edit quantity in base unit" button	
		And I click "Save" button		
	* Check RowIDInfo
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                       | 'Next step' | 'Quantity'     | 'Current step' |
			| '1' | 'Sales invoice 102 dated 05.03.2021 12:57:59' | ''          | '1,000' | 'SRO&SR'       |
			| '2' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''          | '2,000' | 'SRO&SR'       |
			| '3' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''          | '4,000' | 'SRO&SR'       |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Unlink line
		And I click "Link unlink basis documents" button		
		Then "Link / unlink document row" window is opened
		And I set checkbox "Linked documents"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '2,000'    | 'Boots (37/18SD)'   | 'Store 01' | 'pcs'  |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "ResultsTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '700,00' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  |
		And I click "Unlink" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Unit' | 'Sales invoice'                               | 'Item key' |
			| 'Boots' | '1,000'    | 'pcs'  | 'Sales invoice 102 dated 05.03.2021 12:57:59' | '37/18SD'  |
			| 'Boots' | '2,000'    | 'pcs'  | ''                                            | '37/18SD'  |
			| 'Dress' | '4,000'    | 'pcs'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'M/White'  |
	* Link line
		And I click "Link unlink basis documents" button
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '2,000'    | 'Boots (37/18SD)'   | 'Store 01' | 'pcs'  |
		And I set checkbox "Linked documents"
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '700,00' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  |
		And I click "Link" button
		And I click "Ok" button
		And I click "Save" button
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                       | 'Next step' | 'Quantity'     | 'Current step' |
			| '1' | 'Sales invoice 102 dated 05.03.2021 12:57:59' | ''          | '1,000' | 'SRO&SR'       |
			| '2' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''          | '2,000' | 'SRO&SR'       |
			| '3' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''          | '4,000' | 'SRO&SR'       |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And "ItemList" table contains lines
			| 'Item'  | 'Quantity'     | 'Unit' | 'Sales invoice'                               | 'Item key' |
			| 'Boots' | '1,000' | 'pcs'  | 'Sales invoice 102 dated 05.03.2021 12:57:59' | '37/18SD'  |
			| 'Boots' | '2,000' | 'pcs'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' | '37/18SD'  |
			| 'Dress' | '4,000' | 'pcs'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'M/White'  |
	* Delete string, add it again, change unit
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity' | 'Store'    |
			| 'Boots' | '37/18SD'  | '2,000'    | 'Store 01' |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click "Add basis documents" button
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '700,00' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Quantity'     | 'Unit' | 'Sales invoice'                               | 'Item key' |
			| 'Boots' | '1,000' | 'pcs'  | 'Sales invoice 102 dated 05.03.2021 12:57:59' | '37/18SD'  |
			| 'Boots' | '2,000' | 'pcs'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' | '37/18SD'  |
			| 'Dress' | '4,000' | 'pcs'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'M/White'  |
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity'     | 'Store'    |
			| 'Boots' | '37/18SD'  | '2,000' | 'Store 01' |
		And I activate "Unit" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots (12 pcs)' |
		And I select current line in "List" table
		And I click "Save" button
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                       | 'Next step' | 'Quantity'      | 'Current step' |
			| '1' | 'Sales invoice 102 dated 05.03.2021 12:57:59' | ''          | '1,000'  | 'SRO&SR'       |
			| '2' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''          | '4,000'  | 'SRO&SR'       |
			| '3' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''          | '24,000' | 'SRO&SR'       |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Unlink all lines
		And I click "Link unlink basis documents" button
		And I set checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I go to line in "ItemListRows" table
			| 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '1,000'    | 'Boots (37/18SD)'  | 'Store 01' | 'pcs'  |
		And "BasisesTree" table contains lines
			| 'Row presentation'                            | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''         | ''     | ''       | ''         |
			| 'Boots (37/18SD)'                             | '2,000'    | 'pcs'  | '700,00' | 'TRY'      |
			| 'Sales invoice 102 dated 05.03.2021 12:57:59' | ''         | ''     | ''       | ''         |
			| 'Boots (37/18SD)'                             | '1,000'    | 'pcs'  | '700,00' | 'TRY'      |		
		And I click "Ok" button
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Store'    | 'Stock quantity'        | 'Item'  | 'Quantity' | 'Unit'           | 'Tax amount' | 'Price'    | 'VAT' | 'Net amount' | 'Total amount' | 'Sales invoice' | 'Revenue type' | 'Item key' |
			| 'Store 01' | '1,000'                 | 'Boots' | '1,000'    | 'pcs'            | '106,78'     | '700,00'   | '18%' | '593,22'     | '700,00'       | ''              | 'Revenue'      | '37/18SD'  |
			| 'Store 01' | '4,000'                 | 'Dress' | '4,000'    | 'pcs'            | '317,29'     | '520,00'   | '18%' | '1 762,71'   | '2 080,00'     | ''              | 'Revenue'      | 'M/White'  |
			| 'Store 01' | '24,000'                | 'Boots' | '2,000'    | 'Boots (12 pcs)' | '2 562,71'   | '8 400,00' | '18%' | '14 237,29'  | '16 800,00'    | ''              | 'Revenue'      | '37/18SD'  |
		Then the number of "ItemList" table lines is "равно" "3"					
		And I close all client application windows



Scenario: _2060006 check link/unlink form in the RRR
	* Open form for create RRR
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 03  |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Customer'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Customer'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Customer partner term'     |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Shop 01' |
		And I select current line in "List" table		
	* Select items from basis documents
		And I click "Add basis documents" button
		Then "Add linked document rows" window is opened
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'    | 'Quantity' | 'Row presentation' | 'Unit'           | 'Use' |
			| 'TRY'      | '7 777,80' | '1,000'    | 'Boots (36/18SD)'  | 'Boots (12 pcs)' | 'No'  |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '440,68' | '1,000'    | 'Dress (XS/Blue)'  | 'pcs'  | 'No'  |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table	
		And I click "Ok" button
		And I click "Show row key" button
		And I click "Save" button		
	* Check RowIDInfo
		And "RowIDInfo" table became equal
			| '#' | 'Key' | 'Basis'                                              | 'Row ID' | 'Next step' | 'Quantity' | 'Basis key' | 'Current step' | 'Row ref' |
			| '1' | '*'   | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | '*'      | ''          | '1,000'    | '*'         | 'RRR&RGR'      | '*'       |
			| '2' | '*'   | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | '*'      | ''          | '12,000'   | '*'         | 'RRR&RGR'      | '*'       |
		Then the number of "RowIDInfo" table lines is "равно" "2"
	* Unlink line
		And I click "Link unlink basis documents" button		
		Then "Link / unlink document row" window is opened
		And I set checkbox "Linked documents"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit'           |
			| '2' | '1,000'    | 'Boots (36/18SD)'  | 'Store 03' | 'Boots (12 pcs)' |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "ResultsTree" table
			| 'Currency' | 'Price'    | 'Quantity' | 'Row presentation' | 'Unit'           |
			| 'TRY'      | '7 777,80' | '1,000'    | 'Boots (36/18SD)'  | 'Boots (12 pcs)' |
		And I click "Unlink" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Store'    | 'Retail sales receipt'                               | 'Item'  | 'Unit'           | 'Item key' | 'Quantity' |
			| 'Store 03' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | 'Dress' | 'pcs'            | 'XS/Blue'  | '1,000'    |
			| 'Store 03' | ''                                                   | 'Boots' | 'Boots (12 pcs)' | '36/18SD'  | '1,000'    |				
	* Link line
		And I click "Link unlink basis documents" button
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit'            |
			| '2' | '1,000'    | 'Boots (36/18SD)'  | 'Store 03' | 'Boots (12 pcs)'  |
		And I set checkbox "Linked documents"
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'    | 'Quantity' | 'Row presentation' | 'Unit'           |
			| 'TRY'      | '7 777,80' | '1,000'    | 'Boots (36/18SD)'  | 'Boots (12 pcs)' |
		And I click "Link" button
		And I click "Ok" button
		And I click "Save" button
		And "RowIDInfo" table became equal
			| '#' | 'Key' | 'Basis'                                              | 'Row ID' | 'Next step' | 'Quantity' | 'Basis key' | 'Current step' | 'Row ref' |
			| '1' | '*'   | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | '*'      | ''          | '1,000'    | '*'         | 'RRR&RGR'      | '*'       |
			| '2' | '*'   | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | '*'      | ''          | '12,000'   | '*'         | 'RRR&RGR'      | '*'       |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And "ItemList" table contains lines
			| 'Retail sales receipt'                               | 'Item'  | 'Item key' | 'Quantity' | 'Price'    |
			| 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | 'Dress' | 'XS/Blue'  | '1,000'    | '440,68'   |
			| 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | 'Boots' | '36/18SD'  | '1,000'    | '7 777,80' |		
	* Delete string, add it again, change unit
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity' | 'Store'    |
			| 'Boots' | '36/18SD'  | '1,000'    | 'Store 03' |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click "Add basis documents" button
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'    | 'Quantity' | 'Row presentation' | 'Unit'           | 'Use' |
			| 'TRY'      | '7 777,80' | '1,000'    | 'Boots (36/18SD)'  | 'Boots (12 pcs)' | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Retail sales receipt'                               | 'Item'  | 'Item key' | 'Quantity' | 'Price'    |
			| 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | 'Dress' | 'XS/Blue'  | '1,000'    | '440,68'   |
			| 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | 'Boots' | '36/18SD'  | '1,000'    | '7 777,80' |
	* Unlink all lines
		And I click "Link unlink basis documents" button
		And I set checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Retail sales receipt' | 'Item'  | 'Unit'           | 'Item key' | 'Quantity' | 'Price'    |
			| ''                     | 'Dress' | 'pcs'            | 'XS/Blue'  | '1,000'    | '440,68'   |
			| ''                     | 'Boots' | 'Boots (12 pcs)' | '36/18SD'  | '1,000'    | '7 777,80' |
		Then the number of "ItemList" table lines is "равно" "2"					
		And I close all client application windows

Scenario: _2060007 select items from basis documents in the PI
		And I close all client application windows
	* Open form for create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor DFC'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'  |
		And I select current line in "List" table
	* Select items from basis documents
		And I click "Add basis documents" button
		And I expand current line in "BasisesTree" table
		And "BasisesTree" table contains lines 
			| 'Row presentation'                               | 'Use' | 'Quantity' | 'Unit'           | 'Price'    | 'Currency' |
			| 'Sales order 31 dated 27.01.2021 19:50:45'       | 'No'  | ''         | ''               | ''         | ''         |
			| 'Boots (37/18SD)'                                | 'No'  | '2,000'    | 'Boots (12 pcs)' | '8 400,00' | 'TRY'      |
			| 'Purchase order 1 051 dated 20.07.2021 10:22:16' | 'No'  | ''         | ''               | ''         | ''         |
			| 'Dress (S/Yellow)'                               | 'No'  | '55,000'   | 'pcs'            | '550,00'   | 'TRY'      |
			| 'Dress (XS/Blue)'                                | 'No'  | '250,000'  | 'pcs'            | '520,00'   | 'TRY'      |
			| 'Goods receipt 1 051 dated 20.07.2021 10:23:22'  | 'No'  | ''         | ''               | ''         | ''         |
			| 'Dress (S/Yellow)'                               | 'No'  | '45,000'   | 'pcs'            | '550,00'   | 'TRY'      |
			| 'Dress (XS/Blue)'                                | 'No'  | '750,000'  | 'pcs'            | '520,00'   | 'TRY'      |
			| 'Goods receipt 1 052 dated 20.07.2021 10:23:55'  | 'No'  | ''         | ''               | ''         | ''         |
			| 'Dress (S/Yellow)'                               | 'No'  | '5,000'    | 'pcs'            | ''         | ''         |
			| 'Dress (XS/Blue)'                                | 'No'  | '50,000'   | 'pcs'            | ''         | ''         |
			| 'Trousers (36/Yellow)'                            | 'No'  | '40,000'   | 'pcs'            | ''         | ''         |
		Then the number of "BasisesTree" table lines is "равно" "12"
		And I close all client application windows


Scenario: _2060008 check link/unlink form in the PRO
	* Open form for create PRO
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company | 
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Adel'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Vendor, TRY'     |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 02  |
		And I select current line in "List" table	
	* Select items from basis documents
		And I click the button named "AddBasisDocuments"
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '10,000'   | 'Dress (M/White)'  | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'    | 'Quantity' | 'Row presentation' | 'Unit'           | 'Use' |
			| 'TRY'      | '8 400,00' | '2,000'    | 'Boots (36/18SD)'  | 'Boots (12 pcs)' | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '3,000'    | 'Dress (M/White)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Show row key" button
		And in the table "ItemList" I click "Edit quantity in base unit" button	
		And I click "Post" button		
	* Check RowIDInfo
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                          | 'Next step' | 'Quantity'      | 'Current step' |
			| '1' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'PR'        | '10,000' | 'PRO&PR'       |
			| '2' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'PR'        | '3,000'  | 'PRO&PR'       |
			| '3' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'PR'        | '24,000' | 'PRO&PR'       |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Unlink line
		And I click the button named "LinkUnlinkBasisDocuments"			
		Then "Link / unlink document row" window is opened
		And I set checkbox "Linked documents"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '3,000'    | 'Dress (M/White)'   | 'Store 02' | 'pcs'  |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I click "Unlink" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity'      | 'Unit'           | 'Purchase invoice'                               |
			| 'Dress' | 'M/White'  | '10,000' | 'pcs'            | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
			| 'Dress' | 'M/White'  | '3,000'  | 'pcs'            | ''                                               |
			| 'Boots' | '36/18SD'  | '2,000'  | 'Boots (12 pcs)' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |				
	* Link line
		And I click the button named "LinkUnlinkBasisDocuments"	
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '3,000'    | 'Dress (M/White)'   | 'Store 02' | 'pcs'  |
		And I set checkbox "Linked documents"
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '3,000'    | 'Dress (M/White)'  | 'pcs'  |
		And I click "Link" button
		And I click "Ok" button
		And I click "Save" button
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                          | 'Next step' | 'Quantity'      | 'Current step' |
			| '1' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'PR'        | '10,000' | 'PRO&PR'       |
			| '2' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'PR'        | '3,000'  | 'PRO&PR'       |
			| '3' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'PR'        | '24,000' | 'PRO&PR'       |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity'      | 'Unit'           | 'Purchase invoice'                               |
			| 'Dress' | 'M/White'  | '10,000' | 'pcs'            | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
			| 'Dress' | 'M/White'  | '3,000'  | 'pcs'            | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
			| 'Boots' | '36/18SD'  | '2,000'  | 'Boots (12 pcs)' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
	* Delete string, add it again, change unit
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity'     | 'Store'    |
			| 'Dress' | 'M/White'  | '3,000' | 'Store 02' |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "AddBasisDocuments"
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '3,000'    | 'Dress (M/White)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity'      | 'Unit'           | 'Purchase invoice'                               |
			| 'Dress' | 'M/White'  | '10,000' | 'pcs'            | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
			| 'Dress' | 'M/White'  | '3,000'  | 'pcs'            | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
			| 'Boots' | '36/18SD'  | '2,000'  | 'Boots (12 pcs)' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity'     | 'Store'    |
			| 'Boots' | '36/18SD'  | '2,000' | 'Store 02' |
		And I activate "Unit" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs' |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity' | 'Store'    |
			| 'Boots' | '36/18SD'  | '2,000'    | 'Store 02' |
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "700,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table	
		And I click "Save" button
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                          | 'Next step' | 'Quantity'      | 'Current step' |
			| '1' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'PR'        | '10,000' | 'PRO&PR'       |
			| '2' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'PR'        | '2,000'  | 'PRO&PR'       |
			| '3' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'PR'        | '3,000' | 'PRO&PR'       |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Unlink all lines
		And I click the button named "LinkUnlinkBasisDocuments"	
		And I set checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I go to line in "ItemListRows" table
			| 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '10,000'   | 'Dress (M/White)'  | 'Store 02' | 'pcs'  |
		And "BasisesTree" table contains lines
			| 'Row presentation'                               | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Purchase invoice 101 dated 05.03.2021 12:14:08' | ''         | ''     | ''       | ''         |
			| 'Dress (M/White)'                                | '10,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (M/White)'                                | '3,000'    | 'pcs'  | '520,00' | 'TRY'      |			
		And I click "Ok" button
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Store'    | 'Stock quantity'        | '#' | 'Item'  | 'Item key' | 'Cancel' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Purchase invoice' | 'Net amount' | 'Total amount' | 'Expense type' |
			| 'Store 02' | '10,000'                | '1' | 'Dress' | 'M/White'  | 'No'     | '10,000'   | 'pcs'  | '936,00'     | '520,00' | '18%' | ''                 | '5 200,00'   | '6 136,00'     | ''             |
			| 'Store 02' | '2,000'                 | '2' | 'Boots' | '36/18SD'  | 'No'     | '2,000'    | 'pcs'  | '252,00'     | '700,00' | '18%' | ''                 | '1 400,00'   | '1 652,00'     | ''             |
			| 'Store 02' | '3,000'                 | '3' | 'Dress' | 'M/White'  | 'No'     | '3,000'    | 'pcs'  | '280,80'     | '520,00' | '18%' | ''                 | '1 560,00'   | '1 840,80'     | ''             |
		Then the number of "ItemList" table lines is "равно" "3"					
		And I close all client application windows


Scenario: _2060008 check link/unlink form in the PR
	* Open form for create PR
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company | 
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Adel'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Vendor, TRY'     |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 02  |
		And I select current line in "List" table	
	* Select items from basis documents
		And I click the button named "AddBasisDocuments"
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '10,000'   | 'Dress (M/White)'  | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'    | 'Quantity' | 'Row presentation' | 'Unit'           | 'Use' |
			| 'TRY'      | '8 400,00' | '2,000'    | 'Boots (36/18SD)'  | 'Boots (12 pcs)' | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '3,000'    | 'Dress (M/White)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Show row key" button
		And in the table "ItemList" I click "Edit quantity in base unit" button	
		And I click "Post" button		
	* Check RowIDInfo
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                          | 'Next step' | 'Quantity' | 'Current step' |
			| '1' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'SC'        | '10,000'   | 'PRO&PR'       |
			| '2' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'SC'        | '3,000'    | 'PRO&PR'       |
			| '3' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'SC'        | '24,000'   | 'PRO&PR'       |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Unlink line
		And I click the button named "LinkUnlinkBasisDocuments"			
		Then "Link / unlink document row" window is opened
		And I set checkbox "Linked documents"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '3,000'    | 'Dress (M/White)'   | 'Store 02' | 'pcs'  |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I click "Unlink" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity'      | 'Unit'           | 'Purchase invoice'                               |
			| 'Dress' | 'M/White'  | '10,000' | 'pcs'            | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
			| 'Dress' | 'M/White'  | '3,000'  | 'pcs'            | ''                                               |
			| 'Boots' | '36/18SD'  | '2,000'  | 'Boots (12 pcs)' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |				
	* Link line
		And I click the button named "LinkUnlinkBasisDocuments"	
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '3,000'    | 'Dress (M/White)'   | 'Store 02' | 'pcs'  |
		And I set checkbox "Linked documents"
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '3,000'    | 'Dress (M/White)'  | 'pcs'  |
		And I click "Link" button
		And I click "Ok" button
		And I click "Save" button
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                          | 'Next step' | 'Quantity'      | 'Current step' |
			| '1' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'SC'          | '10,000' | 'PRO&PR'       |
			| '2' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'SC'          | '3,000'  | 'PRO&PR'       |
			| '3' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'SC'          | '24,000' | 'PRO&PR'       |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity'      | 'Unit'           | 'Purchase invoice'                               |
			| 'Dress' | 'M/White'  | '10,000' | 'pcs'            | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
			| 'Dress' | 'M/White'  | '3,000'  | 'pcs'            | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
			| 'Boots' | '36/18SD'  | '2,000'  | 'Boots (12 pcs)' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
	* Delete string, add it again, change unit
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity'     | 'Store'    |
			| 'Dress' | 'M/White'  | '3,000' | 'Store 02' |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "AddBasisDocuments"
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '3,000'    | 'Dress (M/White)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity'      | 'Unit'           | 'Purchase invoice'                               |
			| 'Dress' | 'M/White'  | '10,000' | 'pcs'            | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
			| 'Dress' | 'M/White'  | '3,000'  | 'pcs'            | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
			| 'Boots' | '36/18SD'  | '2,000'  | 'Boots (12 pcs)' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' |
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity'     | 'Store'    |
			| 'Boots' | '36/18SD'  | '2,000' | 'Store 02' |
		And I activate "Unit" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs' |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity' | 'Store'    |
			| 'Boots' | '36/18SD'  | '2,000'    | 'Store 02' |
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "700,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table	
		And I click "Save" button
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                          | 'Next step' | 'Quantity'      | 'Current step' |
			| '1' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'SC'          | '10,000' | 'PRO&PR'       |
			| '2' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'SC'          | '2,000'  | 'PRO&PR'       |
			| '3' | 'Purchase invoice 101 dated 05.03.2021 12:14:08' | 'SC'          | '3,000'  | 'PRO&PR'       |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Unlink all lines
		And I click the button named "LinkUnlinkBasisDocuments"	
		And I set checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I go to line in "ItemListRows" table
			| 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '10,000'   | 'Dress (M/White)'  | 'Store 02' | 'pcs'  |
		And "BasisesTree" table contains lines
			| 'Row presentation'                               | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Purchase invoice 101 dated 05.03.2021 12:14:08' | ''         | ''     | ''       | ''         |
			| 'Dress (M/White)'                                | '10,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (M/White)'                                | '3,000'    | 'pcs'  | '520,00' | 'TRY'      |			
		And I click "Ok" button
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Store'    | 'Stock quantity'        | '#' | 'Item'  | 'Item key' | 'Quantity'      | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Purchase invoice' | 'Net amount' | 'Total amount' | 'Expense type' |
			| 'Store 02' | '10,000'                | '1' | 'Dress' | 'M/White'  | '10,000' | 'pcs'  | '936,00'     | '520,00' | '18%' | ''                 | '5 200,00'   | '6 136,00'     | ''             |
			| 'Store 02' | '2,000'                 | '2' | 'Boots' | '36/18SD'  | '2,000'  | 'pcs'  | '252,00'     | '700,00' | '18%' | ''                 | '1 400,00'   | '1 652,00'     | ''             |
			| 'Store 02' | '3,000'                 | '3' | 'Dress' | 'M/White'  | '3,000'  | 'pcs'  | '280,80'     | '520,00' | '18%' | ''                 | '1 560,00'   | '1 840,80'     | ''             |
		Then the number of "ItemList" table lines is "равно" "3"					
		And I close all client application windows

Scenario: _2060010 select items from basis documents in the SI
	* Open form for create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	* Select items from basis documents
		And I click "Add basis documents" button
		And I expand current line in "BasisesTree" table
		And "BasisesTree" table contains lines 
			| 'Row presentation'                                      | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11'           | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                       | '55,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                      | '250,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 051 dated 20.07.2021 10:44:31' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                       | '45,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                      | '750,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 052 dated 20.07.2021 10:44:57' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                       | '5,000'    | 'pcs'  | ''       | ''         |
			| 'Dress (S/Yellow)'                                      | '100,000'  | 'pcs'  | ''       | ''         |
		Then the number of "BasisesTree" table lines is "равно" "9"
		And I close all client application windows

Scenario: _2060015 check form select items from basis documents in the SI
	* Open form for create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	* Select items from basis documents
		And I click "Add basis documents" button
		And I expand current line in "BasisesTree" table
		And "BasisesTree" table contains lines
			| 'Row presentation'                                      | 'Use' | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11'           | 'No'  | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                       | 'No'  | '55,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                      | 'No'  | '250,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 051 dated 20.07.2021 10:44:31' | 'No'  | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                       | 'No'  | '45,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                      | 'No'  | '750,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 052 dated 20.07.2021 10:44:57' | 'No'  | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                       | 'No'  | '5,000'    | 'pcs'  | ''       | ''         |
			| 'Dress (S/Yellow)'                                      | 'No'  | '100,000'  | 'pcs'  | ''       | ''         |
	* Check use/unused all related documents
		And I go to line in "BasisesTree" table
			| 'Row presentation'                            | 'Use' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11' | 'No'  |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And "BasisesTree" table contains lines
			| 'Row presentation'                                   | 'Use' | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11'        | 'Yes' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'Yes' | '55,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'Yes' | '250,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 051 dated 20.07.2021 10:44:31' | 'Yes' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'Yes' | '45,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'Yes' | '750,000'  | 'pcs'  | '550,00' | 'TRY'      |
		And I go to line in "BasisesTree" table
			| 'Row presentation'                                   | 'Use' |
			| 'Shipment confirmation 1 051 dated 20.07.2021 10:44:31' | 'Yes' |
		And I remove "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And "BasisesTree" table contains lines
			| 'Row presentation'                                   | 'Use' | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11'        | 'Yes' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'Yes' | '55,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'Yes' | '250,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 051 dated 20.07.2021 10:44:31' | 'No'  | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'No'  | '45,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'No'  | '750,000'  | 'pcs'  | '550,00' | 'TRY'      |
		And I go to line in "BasisesTree" table
			| 'Row presentation'                                   | 'Use' |
			| 'Shipment confirmation 1 052 dated 20.07.2021 10:44:57' | 'No'  |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Row presentation'                            | 'Use' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11' | 'Yes' |
		And I remove "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And "BasisesTree" table contains lines
			| 'Row presentation'                                   | 'Use' | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11'        | 'No'  | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'No'  | '55,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'No'  | '250,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 051 dated 20.07.2021 10:44:31' | 'No'  | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'No'  | '45,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'No'  | '750,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 052 dated 20.07.2021 10:44:57' | 'Yes' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'Yes' | '5,000'    | 'pcs'  | ''       | ''         |
			| 'Dress (S/Yellow)'                                    | 'Yes' | '100,000'  | 'pcs'  | ''       | ''         |
		And I close all client application windows

Scenario: _2060015 check price in the SI when link document with different price
	* Open form for create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	* Add items
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
			| 'Dress' | 'XS/Blue' |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
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
			| 'Dress' | 'S/Yellow' |
		And I select current line in "List" table
	* Change price
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Price type'        | 'Quantity'     |
			| 'Dress' | 'XS/Blue'  | '520,00' | 'Basic Price Types' | '1,000' |
		And I select current line in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Change price type
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'S/Yellow' |
		And I select current line in "ItemList" table
		And I click choice button of "Price type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Currency' | 'Description'             |
			| 'TRY'      | 'Basic Price without VAT' |
		And I select current line in "List" table
	* Link document
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '1' | '1,000'    | 'Dress (XS/Blue)'  | 'Store 01' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '520,00' | '55,000'   | 'Dress (XS/Blue)'  | 'pcs'  |
		And I click the button named "Link"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '1,000'    | 'Dress (S/Yellow)' | 'Store 01' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '550,00' | '250,000'  | 'Dress (S/Yellow)' | 'pcs'  |
		And I click the button named "Link"
		And I click "Ok" button
	* Check item tab
		And "ItemList" table contains lines
			| '#' | 'Price type'              | 'Item'  | 'Item key' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Store'    | 'Use shipment confirmation' | 'Sales order'                                 |
			| '1' | 'en description is empty' | 'Dress' | 'XS/Blue'  | '1,000'    | 'pcs'  | '76,27'      | '500,00' | '18%' | '423,73'     | '500,00'       | 'Store 01' | 'No'                        | 'Sales order 1 051 dated 20.07.2021 10:44:11' |
			| '2' | 'Basic Price Types'       | 'Dress' | 'S/Yellow' | '1,000'    | 'pcs'  | '83,90'      | '550,00' | '18%' | '466,10'     | '550,00'       | 'Store 01' | 'No'                        | 'Sales order 1 051 dated 20.07.2021 10:44:11' |
		And I close all client application windows


Scenario: _2060016 check price in the PI when link document with different price
	* Open form for create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor DFC'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'  |
		And I select current line in "List" table
	* Add items
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
			| 'Dress' | 'XS/Blue' |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
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
			| 'Dress' | 'S/Yellow' |
		And I select current line in "List" table
	* Change price
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Price type'        | 'Quantity'     |
			| 'Dress' | 'XS/Blue'  | '520,00' | 'Basic Price Types' | '1,000' |
		And I select current line in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Change price type
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'S/Yellow' |
		And I select current line in "ItemList" table
		And I click choice button of "Price type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Currency' | 'Description'             |
			| 'TRY'      | 'Basic Price without VAT' |
		And I select current line in "List" table
	* Link document
		And I click "Link unlink basis documents" button	
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '1' | '1,000'    | 'Dress (XS/Blue)'  | 'Store 03' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '520,00' | '250,000'   | 'Dress (XS/Blue)'  | 'pcs'  |
		And I click the button named "Link"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '1,000'    | 'Dress (S/Yellow)' | 'Store 03' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '550,00' | '55,000'  | 'Dress (S/Yellow)' | 'pcs'  |
		And I click the button named "Link"
		And I click "Ok" button
	* Check item tab
		And "ItemList" table contains lines
			| 'Price type'              | 'Item'  | 'Item key' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Quantity'     | 'Price'  | 'VAT' | 'Total amount' | 'Store'    | 'Purchase order'                                 | 'Net amount' | 'Use goods receipt' |
			| 'en description is empty' | 'Dress' | 'XS/Blue'  | 'No'                 | '90,00'      | 'pcs'  | '1,000' | '500,00' | '18%' | '590,00'       | 'Store 03' | 'Purchase order 1 051 dated 20.07.2021 10:22:16' | '500,00'     | 'Yes'               |
			| 'Basic Price Types'       | 'Dress' | 'S/Yellow' | 'No'                 | '99,00'      | 'pcs'  | '1,000' | '550,00' | '18%' | '649,00'       | 'Store 03' | 'Purchase order 1 051 dated 20.07.2021 10:22:16' | '550,00'     | 'Yes'               |		
		And I close all client application windows
	

Scenario: _2060017 check link form in the SI with 3 lines with the same items
	* Open form for create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Lomaniti'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Lomaniti'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	* Add items	
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Scarf'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Scarf' | 'XS/Red'  |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "99,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table 
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Scarf'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Scarf' | 'XS/Red'  |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table 
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Scarf'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Scarf' | 'XS/Red'  |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Link 
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I go to line in "ItemListRows" table
			| 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '99,000'   | 'Scarf (XS/Red)'   | 'Store 01' | 'pcs'  |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '100,00' | '100,000'  | 'Scarf (XS/Red)'   | 'pcs'  |
		And I click the button named "Link"
		And I go to line in "ItemListRows" table
			| 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '3,000'    | 'Scarf (XS/Red)'   | 'Store 01' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '100,00' | '5,000'    | 'Scarf (XS/Red)'   | 'pcs'  |
		And I click the button named "Link"
		And I go to line in "ItemListRows" table
			| 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '1,000'    | 'Scarf (XS/Red)'   | 'Store 01' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '100,00' | '100,000'  | 'Scarf (XS/Red)'   | 'pcs'  |
		And I click the button named "Link"
		Then the number of "BasisesTree" table lines is "равно" 0
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '3,000'    | 'Scarf (XS/Red)'   | 'Store 01' | 'pcs'  |
		Then the number of "BasisesTree" table lines is "равно" 0
		And I set checkbox "Linked documents"
		And "ResultsTree" table became equal
			| 'Row presentation'                                   | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 1 052 dated 07.09.2021 21:06:20'        | ''         | ''     | ''       | ''         |
			| 'Shipment confirmation 1 053 dated 07.09.2021 21:07:30' | ''         | ''     | ''       | ''         |
			| 'Scarf (XS/Red)'                                     | '99,000'   | 'pcs'  | '100,00' | 'TRY'      |
			| 'Scarf (XS/Red)'                                     | '1,000'    | 'pcs'  | '100,00' | 'TRY'      |
			| 'Sales order 1 053 dated 07.09.2021 10:00:00'        | ''         | ''     | ''       | ''         |
			| 'Scarf (XS/Red)'                                     | '3,000'    | 'pcs'  | '100,00' | 'TRY'      |
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#' | 'Revenue type' | 'Price type'              | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order'                                 |
			| '1' | ''             | 'en description is empty' | 'Scarf' | 'XS/Red'   | ''                   | 'No'                 | ''                   | '99,000'   | 'pcs'  | '1 608,19'   | '100,00' | '18%' | ''              | '8 291,81'   | '9 900,00'     | ''                    | 'Store 01' | ''              | 'Yes'                       | ''       | 'Sales order 1 052 dated 07.09.2021 21:06:20' |
			| '2' | ''             | 'en description is empty' | 'Scarf' | 'XS/Red'   | ''                   | 'No'                 | ''                   | '3,000'    | 'pcs'  | '48,73'      | '100,00' | '18%' | ''              | '251,27'     | '300,00'       | ''                    | 'Store 01' | ''              | 'No'                        | ''       | 'Sales order 1 053 dated 07.09.2021 10:00:00' |
			| '3' | ''             | 'en description is empty' | 'Scarf' | 'XS/Red'   | ''                   | 'No'                 | ''                   | '1,000'    | 'pcs'  | '16,24'      | '100,00' | '18%' | ''              | '83,76'      | '100,00'       | ''                    | 'Store 01' | ''              | 'Yes'                       | ''       | 'Sales order 1 052 dated 07.09.2021 21:06:20' |
	* Auto link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I set checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And "BasisesTree" table became equal
			| 'Row presentation'                                   | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 1 053 dated 07.09.2021 10:00:00'        | ''         | ''     | ''       | ''         |
			| 'Scarf (XS/Red)'                                     | '5,000'    | 'pcs'  | '100,00' | 'TRY'      |
			| 'Sales order 1 052 dated 07.09.2021 21:06:20'        | ''         | ''     | ''       | ''         |
			| 'Shipment confirmation 1 053 dated 07.09.2021 21:07:30' | ''         | ''     | ''       | ''         |
			| 'Scarf (XS/Red)'                                     | '100,000'  | 'pcs'  | '100,00' | 'TRY'      |
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#' | 'Revenue type' | 'Price type'              | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order' |
			| '1' | ''             | 'en description is empty' | 'Scarf' | 'XS/Red'   | ''                   | 'No'                 | ''                   | '99,000'   | 'pcs'  | '1 608,19'   | '100,00' | '18%' | ''              | '8 291,81'   | '9 900,00'     | ''                    | 'Store 01' | ''              | 'Yes'                       | ''       | ''            |
			| '2' | ''             | 'en description is empty' | 'Scarf' | 'XS/Red'   | ''                   | 'No'                 | ''                   | '3,000'    | 'pcs'  | '48,73'      | '100,00' | '18%' | ''              | '251,27'     | '300,00'       | ''                    | 'Store 01' | ''              | 'No'                        | ''       | ''            |
			| '3' | ''             | 'en description is empty' | 'Scarf' | 'XS/Red'   | ''                   | 'No'                 | ''                   | '1,000'    | 'pcs'  | '16,24'      | '100,00' | '18%' | ''              | '83,76'      | '100,00'       | ''                    | 'Store 01' | ''              | 'Yes'                       | ''       | ''            |
		And I close all client application windows


Scenario: _2060018 check link form in the PI with 2 lines with the same items
	* Open form for create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Vendor Ferron, TRY'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'  |
		And I select current line in "List" table
	* Add items	
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Scarf'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Scarf' | 'XS/Red'  |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "9,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Scarf'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Scarf' | 'XS/Red'  |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Link 
		And I click "Link unlink basis documents" button
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '1' | '9,000'    | 'Scarf (XS/Red)'   | 'Store 03' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '100,00' | '10,000'   | 'Scarf (XS/Red)' | 'pcs'  |
		And I click the button named "Link"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '1,000'    | 'Scarf (XS/Red)'   | 'Store 03' | 'pcs'  |
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                               |
			| 'Purchase order 1 052 dated 07.09.2021 21:34:37' |
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                              |
			| 'Goods receipt 1 053 dated 07.09.2021 21:34:43' |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '100,00' | '10,000'   | 'Scarf (XS/Red)' | 'pcs'  |
		And I click the button named "Link"
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#' | 'Price type'              | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity'     | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Expense type' | 'Purchase order'                                 | 'Detail' | 'Sales order' | 'Net amount' | 'Use goods receipt' |
			| '1' | 'en description is empty' | 'Scarf' | 'XS/Red'   | ''                   | 'No'                 | '137,29'     | 'pcs'  | ''                   | '9,000' | '100,00' | '18%' | ''              | '900,00'       | ''                    | ''                        | 'Store 03' | ''              | ''             | 'Purchase order 1 052 dated 07.09.2021 21:34:37' | ''       | ''            | '762,71'     | 'Yes'               |
			| '2' | 'en description is empty' | 'Scarf' | 'XS/Red'   | ''                   | 'No'                 | '15,25'      | 'pcs'  | ''                   | '1,000' | '100,00' | '18%' | ''              | '100,00'       | ''                    | ''                        | 'Store 03' | ''              | ''             | 'Purchase order 1 052 dated 07.09.2021 21:34:37' | ''       | ''            | '84,75'      | 'Yes'               |
	* Autolink
		And I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#' | 'Price type'              | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity'     | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Expense type' | 'Purchase order'                                 | 'Detail' | 'Sales order' | 'Net amount' | 'Use goods receipt' |
			| '1' | 'en description is empty' | 'Scarf' | 'XS/Red'   | ''                   | 'No'                 | '137,29'     | 'pcs'  | ''                   | '9,000' | '100,00' | '18%' | ''              | '900,00'       | ''                    | ''                        | 'Store 03' | ''              | ''             | 'Purchase order 1 052 dated 07.09.2021 21:34:37' | ''       | ''            | '762,71'     | 'Yes'               |
			| '2' | 'en description is empty' | 'Scarf' | 'XS/Red'   | ''                   | 'No'                 | '15,25'      | 'pcs'  | ''                   | '1,000' | '100,00' | '18%' | ''              | '100,00'       | ''                    | ''                        | 'Store 03' | ''              | ''             | 'Purchase order 1 052 dated 07.09.2021 21:34:37' | ''       | ''            | '84,75'      | 'Yes'               |
		And I close all client application windows
		

Scenario: _2060019 check link form in the PI with Serial Lot number
	* Post test PO
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(1053).GetObject().Write(DocumentWriteMode.Posting);" |
	* Create PI
		* Open form for create PI
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
		* Filling in the main details of the document
			And I click Select button of "Partner" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description' |
				| 'DFC'     |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description' |
				| 'DFC'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description' |
				| 'Partner term vendor DFC'     |
			And I select current line in "List" table
			And I activate field named "ItemListLineNumber" in "ItemList" table		
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' | 
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'  |
			And I select current line in "List" table
		* Add items	
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Phone A'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Phone A' | 'Brown'  |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "500,00" text in the field named "ItemListPrice" of "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'Brown' | '13456778'      |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'Brown' | '12345678'      |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button		
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Phone A'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'    | 'Item key' |
				| 'Phone A' | 'White'  |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "560,00" text in the field named "ItemListPrice" of "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'White' | '12345670'      |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button	
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Phone A'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'    | 'Item key' |
				| 'Phone A' | 'Brown'  |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'Brown' | '13456778'      |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button	
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Router'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'    | 'Item key' |
				| 'Router' | 'Router'  |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
	* Link PI with PO (auto link)
		And I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
	* Check tab
		And "ItemList" table became equal
			| '#' | 'Item'    | 'Item key' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Store'    | 'Quantity' | 'Purchase order'                                 | 'Net amount' | 'Use goods receipt' |
			| '1' | 'Phone A' | 'Brown'    | '180,00'     | 'pcs'  | '13456778; 12345678' | '500,00' | '18%' | ''              | '1 180,00'     | 'Store 03' | '2,000'    | 'Purchase order 1 053 dated 14.09.2021 07:47:34' | '1 000,00'   | 'Yes'               |
			| '2' | 'Phone A' | 'White'    | '100,80'     | 'pcs'  | '12345670'           | '560,00' | '18%' | ''              | '660,80'       | 'Store 03' | '1,000'    | 'Purchase order 1 053 dated 14.09.2021 07:47:34' | '560,00'     | 'Yes'               |
			| '3' | 'Phone A' | 'Brown'    | '39,60'      | 'pcs'  | '13456778'           | '110,00' | '18%' | ''              | '259,60'       | 'Store 03' | '2,000'    | 'Purchase order 1 053 dated 14.09.2021 07:47:34' | '220,00'     | 'Yes'               |
			| '4' | 'Router'  | 'Router'   | '18,00'      | 'pcs'  | ''                   | '100,00' | '18%' | ''              | '118,00'       | 'Store 03' | '1,000'    | 'Purchase order 1 053 dated 14.09.2021 07:47:34' | '100,00'     | 'Yes'               |
		And I close all client application windows



Scenario: _2060020 check button Show quantity in base unit in the Link form
	And I close all client application windows
	* Open form for create SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I select "Sales" exact value from "Transaction type" drop-down list
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Adel'     |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table	
	* Filling in Item tab
		And I move to "Items" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate field named "ItemKey" in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots (12 pcs)' |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I activate field named "Item" in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'box Dress (8 pcs)' |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
	* Check button Show quantity in base unit in the Link form
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I set checkbox "Show quantity in basis unit"
		And "ItemListRows" table contains lines
			| 'Row presentation' | 'Unit'              | 'Quantity' | 'Unit (basis)' | 'Quantity (basis)' | 'Store'    |
			| 'Boots (37/18SD)'  | 'Boots (12 pcs)'    | '2,000'    | 'pcs'          | '24,000'           | 'Store 01' |
			| 'Dress (XS/Blue)'  | 'box Dress (8 pcs)' | '2,000'    | 'pcs'          | '16,000'           | 'Store 01' |
		And I close all client application windows
			
Scenario: _2060021 check button	Select all/ Uncheck all in the Add linked documents rows
		And I close all client application windows
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		Then "Sales invoices" window is opened
		And I go to line in "List" table
			| 'Date'                | 'Number' |
			| '05.03.2021 12:57:59' | '102'    |
		And I click the button named "FormDocumentSalesReturnGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
	* Check Add linked documents rows
		And "BasisesTree" table became equal
			| 'Row presentation'                            | 'Use' | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales invoice 102 dated 05.03.2021 12:57:59' | 'Yes' | ''         | ''     | ''       | ''         |
			| 'Boots (37/18SD)'                             | 'Yes' | '1,000'    | 'pcs'  | '700,00' | 'TRY'      |
			| 'Dress (M/White)'                             | 'Yes' | '2,000'    | 'pcs'  | '520,00' | 'TRY'      |
	* Check Uncheck all
		And I click "Uncheck all" button
		And "BasisesTree" table became equal
			| 'Row presentation'                            | 'Use'| 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales invoice 102 dated 05.03.2021 12:57:59' | 'No' | ''         | ''     | ''       | ''         |
			| 'Boots (37/18SD)'                             | 'No' | '1,000'    | 'pcs'  | '700,00' | 'TRY'      |
			| 'Dress (M/White)'                             | 'No' | '2,000'    | 'pcs'  | '520,00' | 'TRY'      |
	* Check Check all
		And I click "Check all" button
		And "BasisesTree" table became equal
			| 'Row presentation'                            | 'Use' | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales invoice 102 dated 05.03.2021 12:57:59' | 'Yes' | ''         | ''     | ''       | ''         |
			| 'Boots (37/18SD)'                             | 'Yes' | '1,000'    | 'pcs'  | '700,00' | 'TRY'      |
			| 'Dress (M/White)'                             | 'Yes' | '2,000'    | 'pcs'  | '520,00' | 'TRY'      |
		And I close all client application windows
			
Scenario: _2060022 check button	Show row key in the Add linked documents rows
		And I close all client application windows
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		Then "Sales invoices" window is opened
		And I go to line in "List" table
			| 'Date'                | 'Number' |
			| '05.03.2021 12:57:59' | '102'    |
		And I click the button named "FormDocumentSalesReturnGenerate"
		Then "Add linked document rows" window is opened
		And I click "Ok" button
		And in the table "ItemList" I click "Add basis documents" button
		And I expand current line in "BasisesTree" table
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                            | 'Use' |
			| 'Sales invoice 102 dated 05.03.2021 12:57:59' | 'No'  |		
	* Check button Show row key	
		And I click "Show row key" button
		And "ResultsTable" table became equal
			| 'Item'  | 'Item key' | 'Store'    | 'Key' | 'Basis'                                       | 'Unit' | 'Basis unit' | 'Current step' | 'Row ref' | 'Parent basis' | 'Row ID' | 'Basis key' |
			| 'Boots' | '37/18SD'  | 'Store 01' | '*'   | 'Sales invoice 102 dated 05.03.2021 12:57:59' | ''     | 'pcs'        | 'SRO&SR'       | '*'       | ''             | '*'      | '*'         |
			| 'Dress' | 'M/White'  | 'Store 01' | '*'   | 'Sales invoice 102 dated 05.03.2021 12:57:59' | ''     | 'pcs'        | 'SRO&SR'       | '*'       | ''             | '*'      | '*'         |
		And I click "Cancel" button
		Then user message window does not contain messages
		
				
Scenario: _2060023 check auto form in the SC - SO (with sln)
		And I close all client application windows
	* Select first SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number' |
			| '2 054'  |
		And I select current line in "List" table
	* Auto link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#' | 'Item'                         | 'Inventory transfer' | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Quantity' | 'Sales invoice' | 'Store'    | 'Shipment basis'                              | 'Sales order'                                 | 'Inventory transfer order' | 'Purchase return order' | 'Purchase return' |
			| '1' | 'Product 7 with SLN (new row)' | ''                   | 'PZU'      | '9009099'            | 'pcs'  | '1,000'    | ''              | 'Store 01' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | ''                         | ''                      | ''                |
			| '2' | 'Dress'                        | ''                   | 'XS/Blue'  | ''                   | 'pcs'  | '2,000'    | ''              | 'Store 01' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | ''                         | ''                      | ''                |
			| '3' | 'Product 7 with SLN (new row)' | ''                   | 'PZU'      | '9009098'            | 'pcs'  | '1,000'    | ''              | 'Store 01' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | ''                         | ''                      | ''                |
			| '4' | 'Product 7 with SLN (new row)' | ''                   | 'ODS'      | '9009100'            | 'pcs'  | '1,000'    | ''              | 'Store 01' | ''                                            | ''                                            | ''                         | ''                      | ''                |
			| '5' | 'Product 1 with SLN'           | ''                   | 'ODS'      | '9090098908'         | 'pcs'  | '1,000'    | ''              | 'Store 01' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | ''                         | ''                      | ''                |
		Then the number of "ItemList" table lines is "равно" "5"
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number' |
			| '2 054'  |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| '#' | 'Item'                         | 'Inventory transfer' | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Quantity' | 'Sales invoice' | 'Store'    | 'Shipment basis'                              | 'Sales order'                                 | 'Inventory transfer order' | 'Purchase return order' | 'Purchase return' |
			| '1' | 'Product 7 with SLN (new row)' | ''                   | 'PZU'      | '9009099'            | 'pcs'  | '1,000'    | ''              | 'Store 01' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | ''                         | ''                      | ''                |
			| '2' | 'Dress'                        | ''                   | 'XS/Blue'  | ''                   | 'pcs'  | '2,000'    | ''              | 'Store 01' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | ''                         | ''                      | ''                |
			| '3' | 'Product 7 with SLN (new row)' | ''                   | 'PZU'      | '9009098'            | 'pcs'  | '1,000'    | ''              | 'Store 01' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | ''                         | ''                      | ''                |
			| '4' | 'Product 7 with SLN (new row)' | ''                   | 'ODS'      | '9009100'            | 'pcs'  | '1,000'    | ''              | 'Store 01' | ''                                            | ''                                            | ''                         | ''                      | ''                |
			| '5' | 'Product 1 with SLN'           | ''                   | 'ODS'      | '9090098908'         | 'pcs'  | '1,000'    | ''              | 'Store 01' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | ''                         | ''                      | ''                |
		And I close current window
	* Select second SC	
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number' |
			| '2 055'  |
		And I select current line in "List" table	
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button	
		And "ItemList" table became equal
			| '#' | 'Item'                         | 'Inventory transfer' | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Quantity' | 'Sales invoice' | 'Store'    | 'Shipment basis'                              | 'Sales order'                                 | 'Inventory transfer order' | 'Purchase return order' | 'Purchase return' |
			| '1' | 'Product 7 with SLN (new row)' | ''                   | 'PZU'      | '9009098'            | 'pcs'  | '1,000'    | ''              | 'Store 01' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | ''                         | ''                      | ''                |
			| '2' | 'Product 1 with SLN'           | ''                   | 'ODS'      | '9090098908'         | 'pcs'  | '1,000'    | ''              | 'Store 01' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | ''                         | ''                      | ''                |
		Then the number of "ItemList" table lines is "равно" "2"
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number' |
			| '2 055'  |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| '#' | 'Item'                         | 'Inventory transfer' | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Quantity' | 'Sales invoice' | 'Store'    | 'Shipment basis'                              | 'Sales order'                                 | 'Inventory transfer order' | 'Purchase return order' | 'Purchase return' |
			| '1' | 'Product 7 with SLN (new row)' | ''                   | 'PZU'      | '9009098'            | 'pcs'  | '1,000'    | ''              | 'Store 01' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | ''                         | ''                      | ''                |
			| '2' | 'Product 1 with SLN'           | ''                   | 'ODS'      | '9090098908'         | 'pcs'  | '1,000'    | ''              | 'Store 01' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | 'Sales order 2 055 dated 11.04.2023 15:39:39' | ''                         | ''                      | ''                |
		And I close all client application windows
	* Unpost documents
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(2054).GetObject().Write(DocumentWriteMode.UndoPosting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(2055).GetObject().Write(DocumentWriteMode.UndoPosting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(2055).GetObject().Write(DocumentWriteMode.UndoPosting);" |
		
			
				
Scenario: _2060024 check auto form in the SI - SO (with sln)
		And I close all client application windows
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '2 054'  |
		And I select current line in "List" table	
	* Auto link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button	
		And "ItemList" table contains lines
			| '#' | 'Price type'              | 'Item'                         | 'Item key' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Other revenue type'   | 'Store'    | 'Use shipment confirmation' | 'Sales order'                                 |
			| '1' | 'en description is empty' | 'Product 7 with SLN (new row)' | 'PZU'      | 'No'                 | '16,24'      | 'pcs'  | '9009098'            | '1,000'    | '100,00' | '18%' | ''              | '83,76'      | '100,00'       | 'No'             | ''                     | 'Store 01' | 'No'                        | 'Sales order 2 054 dated 11.04.2023 15:25:22' |
			| '2' | 'Basic Price Types'       | 'Dress'                        | 'XS/Blue'  | 'No'                 | '168,94'     | 'pcs'  | ''                   | '2,000'    | '520,00' | '18%' | ''              | '871,06'     | '1 040,00'     | 'No'             | ''                     | 'Store 01' | 'No'                        | 'Sales order 2 054 dated 11.04.2023 15:25:22' |
			| '3' | 'en description is empty' | 'Product 7 with SLN (new row)' | 'PZU'      | 'No'                 | '16,24'      | 'pcs'  | '9009099'            | '1,000'    | '100,00' | '18%' | ''              | '83,76'      | '100,00'       | 'No'             | ''                     | 'Store 01' | 'No'                        | 'Sales order 2 054 dated 11.04.2023 15:25:22' |
			| '4' | 'en description is empty' | 'Product 7 with SLN (new row)' | 'PZU'      | 'No'                 | '16,24'      | 'pcs'  | '9009098'            | '1,000'    | '100,00' | '18%' | ''              | '83,76'      | '100,00'       | 'No'             | ''                     | 'Store 01' | 'No'                        | 'Sales order 2 054 dated 11.04.2023 15:25:22' |
			| '5' | 'en description is empty' | 'Product 7 with SLN (new row)' | 'ODS'      | 'No'                 | '16,24'      | 'pcs'  | '9009100'            | '1,000'    | '100,00' | '18%' | ''              | '83,76'      | '100,00'       | 'No'             | ''                     | 'Store 01' | 'No'                        | ''                                            |
			| '6' | 'en description is empty' | 'Product 1 with SLN'           | 'ODS'      | 'No'                 | '16,24'      | 'pcs'  | '9090098908'         | '1,000'    | '100,00' | '18%' | ''              | '83,76'      | '100,00'       | 'No'             | ''                     | 'Store 01' | 'No'                        | 'Sales order 2 054 dated 11.04.2023 15:25:22' |
		Then the number of "ItemList" table lines is "равно" "6"
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number' |
			| '2 054'  |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| '#' | 'Price type'              | 'Item'                         | 'Item key' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Other revenue type'   | 'Store'    | 'Use shipment confirmation' | 'Sales order'                                 |
			| '1' | 'en description is empty' | 'Product 7 with SLN (new row)' | 'PZU'      | 'No'                 | '16,24'      | 'pcs'  | '9009098'            | '1,000'    | '100,00' | '18%' | ''              | '83,76'      | '100,00'       | 'No'             | ''                     | 'Store 01' | 'No'                        | 'Sales order 2 054 dated 11.04.2023 15:25:22' |
			| '2' | 'Basic Price Types'       | 'Dress'                        | 'XS/Blue'  | 'No'                 | '168,94'     | 'pcs'  | ''                   | '2,000'    | '520,00' | '18%' | ''              | '871,06'     | '1 040,00'     | 'No'             | ''                     | 'Store 01' | 'No'                        | 'Sales order 2 054 dated 11.04.2023 15:25:22' |
			| '3' | 'en description is empty' | 'Product 7 with SLN (new row)' | 'PZU'      | 'No'                 | '16,24'      | 'pcs'  | '9009099'            | '1,000'    | '100,00' | '18%' | ''              | '83,76'      | '100,00'       | 'No'             | ''                     | 'Store 01' | 'No'                        | 'Sales order 2 054 dated 11.04.2023 15:25:22' |
			| '4' | 'en description is empty' | 'Product 7 with SLN (new row)' | 'PZU'      | 'No'                 | '16,24'      | 'pcs'  | '9009098'            | '1,000'    | '100,00' | '18%' | ''              | '83,76'      | '100,00'       | 'No'             | ''                     | 'Store 01' | 'No'                        | 'Sales order 2 054 dated 11.04.2023 15:25:22' |
			| '5' | 'en description is empty' | 'Product 7 with SLN (new row)' | 'ODS'      | 'No'                 | '16,24'      | 'pcs'  | '9009100'            | '1,000'    | '100,00' | '18%' | ''              | '83,76'      | '100,00'       | 'No'             | ''                     | 'Store 01' | 'No'                        | ''                                            |
			| '6' | 'en description is empty' | 'Product 1 with SLN'           | 'ODS'      | 'No'                 | '16,24'      | 'pcs'  | '9090098908'         | '1,000'    | '100,00' | '18%' | ''              | '83,76'      | '100,00'       | 'No'             | ''                     | 'Store 01' | 'No'                        | 'Sales order 2 054 dated 11.04.2023 15:25:22' |
		And I close all client application windows
	* Unpost documents
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2054).GetObject().Write(DocumentWriteMode.UndoPosting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(2054).GetObject().Write(DocumentWriteMode.UndoPosting);" |
		
		
Scenario: _2060025 check auto form in the IT - ITO (with sln)
		And I close all client application windows
	* Select IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number' |
			| '2 054'  |
		And I select current line in "List" table	
	* Auto link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button	
		And "ItemList" table became equal
			| '#' | 'Item'                         | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Quantity' | 'Inventory transfer order'                                 |
			| '1' | 'Product 7 with SLN (new row)' | 'PZU'      | '9009098'            | 'pcs'  | '1,000'    | 'Inventory transfer order 2 054 dated 11.04.2023 15:35:41' |
			| '2' | 'Product 7 with SLN (new row)' | 'PZU'      | '9009098'            | 'pcs'  | '1,000'    | 'Inventory transfer order 2 054 dated 11.04.2023 15:35:41' |
			| '3' | 'Dress'                        | 'XS/Blue'  | ''                   | 'pcs'  | '2,000'    | 'Inventory transfer order 2 054 dated 11.04.2023 15:35:41' |
			| '4' | 'Product 7 with SLN (new row)' | 'PZU'      | '9009099'            | 'pcs'  | '1,000'    | 'Inventory transfer order 2 054 dated 11.04.2023 15:35:41' |
			| '5' | 'Product 7 with SLN (new row)' | 'ODS'      | '9009100'            | 'pcs'  | '1,000'    | ''                                                         |
			| '6' | 'Product 1 with SLN'           | 'ODS'      | '9090098908'         | 'pcs'  | '1,000'    | 'Inventory transfer order 2 054 dated 11.04.2023 15:35:41' |
		Then the number of "ItemList" table lines is "равно" "6"
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number' |
			| '2 054'  |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| '#' | 'Item'                         | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Quantity' | 'Inventory transfer order'                                 |
			| '1' | 'Product 7 with SLN (new row)' | 'PZU'      | '9009098'            | 'pcs'  | '1,000'    | 'Inventory transfer order 2 054 dated 11.04.2023 15:35:41' |
			| '2' | 'Product 7 with SLN (new row)' | 'PZU'      | '9009098'            | 'pcs'  | '1,000'    | 'Inventory transfer order 2 054 dated 11.04.2023 15:35:41' |
			| '3' | 'Dress'                        | 'XS/Blue'  | ''                   | 'pcs'  | '2,000'    | 'Inventory transfer order 2 054 dated 11.04.2023 15:35:41' |
			| '4' | 'Product 7 with SLN (new row)' | 'PZU'      | '9009099'            | 'pcs'  | '1,000'    | 'Inventory transfer order 2 054 dated 11.04.2023 15:35:41' |
			| '5' | 'Product 7 with SLN (new row)' | 'ODS'      | '9009100'            | 'pcs'  | '1,000'    | ''                                                         |
			| '6' | 'Product 1 with SLN'           | 'ODS'      | '9090098908'         | 'pcs'  | '1,000'    | 'Inventory transfer order 2 054 dated 11.04.2023 15:35:41' |
		And I close all client application windows
	* Unpost documents
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransfer.FindByNumber(2054).GetObject().Write(DocumentWriteMode.UndoPosting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransferOrder.FindByNumber(2054).GetObject().Write(DocumentWriteMode.UndoPosting);" |
		
										
			


Scenario: _2060026 check auto form in the Physical inventory - Stock adjustment as write-off (with sln)
		And I close all client application windows
	* Select StockAdjustmentAsWriteOff
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number' |
			| '152'  |
		And I select current line in "List" table	
	* Auto link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button	
		And "ItemList" table became equal
			| '#' | 'Item'                         | 'Basis document'                                   | 'Item key' | 'Profit loss center' | 'Physical inventory'                               | 'Serial lot numbers' | 'Unit' | 'Source of origins' | 'Quantity' | 'Expense type' |
			| '1' | 'Product 7 with SLN (new row)' | 'Physical inventory 152 dated 27.04.2023 13:32:16' | 'ODS'      | 'Front office'       | 'Physical inventory 152 dated 27.04.2023 13:32:16' | '9009100'            | 'pcs'  | ''                  | '1,000'    | 'Expense'      |
			| '2' | 'Product 7 with SLN (new row)' | 'Physical inventory 152 dated 27.04.2023 13:32:16' | 'PZU'      | 'Front office'       | 'Physical inventory 152 dated 27.04.2023 13:32:16' | '9009098'            | 'pcs'  | ''                  | '1,000'    | 'Expense'      |
			| '3' | 'Product 7 with SLN (new row)' | 'Physical inventory 152 dated 27.04.2023 13:32:16' | 'PZU'      | 'Front office'       | 'Physical inventory 152 dated 27.04.2023 13:32:16' | '9009098'            | 'pcs'  | ''                  | '1,000'    | 'Expense'      |
			| '4' | 'Dress'                        | 'Physical inventory 152 dated 27.04.2023 13:32:16' | 'XS/Blue'  | 'Front office'       | 'Physical inventory 152 dated 27.04.2023 13:32:16' | ''                   | 'pcs'  | ''                  | '2,000'    | 'Expense'      |
			| '5' | 'Product 7 with SLN (new row)' | ''                                                 | 'PZU'      | 'Front office'       | ''                                                 | '9009099'            | 'pcs'  | ''                  | '1,000'    | 'Expense'      |
			| '6' | 'Product 1 with SLN'           | 'Physical inventory 152 dated 27.04.2023 13:32:16' | 'ODS'      | 'Front office'       | 'Physical inventory 152 dated 27.04.2023 13:32:16' | '9090098908'         | 'pcs'  | ''                  | '1,000'    | 'Expense'      |		
		Then the number of "ItemList" table lines is "равно" "6"
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number' |
			| '152'  |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| '#' | 'Item'                         | 'Basis document'                                   | 'Item key' | 'Profit loss center' | 'Physical inventory'                               | 'Serial lot numbers' | 'Unit' | 'Source of origins' | 'Quantity' | 'Expense type' |
			| '1' | 'Product 7 with SLN (new row)' | 'Physical inventory 152 dated 27.04.2023 13:32:16' | 'ODS'      | 'Front office'       | 'Physical inventory 152 dated 27.04.2023 13:32:16' | '9009100'            | 'pcs'  | ''                  | '1,000'    | 'Expense'      |
			| '2' | 'Product 7 with SLN (new row)' | 'Physical inventory 152 dated 27.04.2023 13:32:16' | 'PZU'      | 'Front office'       | 'Physical inventory 152 dated 27.04.2023 13:32:16' | '9009098'            | 'pcs'  | ''                  | '1,000'    | 'Expense'      |
			| '3' | 'Product 7 with SLN (new row)' | 'Physical inventory 152 dated 27.04.2023 13:32:16' | 'PZU'      | 'Front office'       | 'Physical inventory 152 dated 27.04.2023 13:32:16' | '9009098'            | 'pcs'  | ''                  | '1,000'    | 'Expense'      |
			| '4' | 'Dress'                        | 'Physical inventory 152 dated 27.04.2023 13:32:16' | 'XS/Blue'  | 'Front office'       | 'Physical inventory 152 dated 27.04.2023 13:32:16' | ''                   | 'pcs'  | ''                  | '2,000'    | 'Expense'      |
			| '5' | 'Product 7 with SLN (new row)' | ''                                                 | 'PZU'      | 'Front office'       | ''                                                 | '9009099'            | 'pcs'  | ''                  | '1,000'    | 'Expense'      |
			| '6' | 'Product 1 with SLN'           | 'Physical inventory 152 dated 27.04.2023 13:32:16' | 'ODS'      | 'Front office'       | 'Physical inventory 152 dated 27.04.2023 13:32:16' | '9090098908'         | 'pcs'  | ''                  | '1,000'    | 'Expense'      |		
		And I close all client application windows
	* Unpost documents
		And I execute 1C:Enterprise script at server
			| "Documents.StockAdjustmentAsWriteOff.FindByNumber(152).GetObject().Write(DocumentWriteMode.UndoPosting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PhysicalInventory.FindByNumber(152).GetObject().Write(DocumentWriteMode.UndoPosting);" |
					
Scenario: _2060028 check SR (different store then in the SI) - GR link form	
	And I close all client application windows
	* Preparation (create SI - Store 01)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I select from the drop-down list named "Partner" by "Kalipso" string
		And I select from "Partner term" drop-down list by "Basic Partner terms, TRY" string
	* Filling in Item tab	
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Dress" from "Item" drop-down list by string in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select "XS/Blue" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "45,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select "dress" from "Item" drop-down list by string in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select "S/Yellow" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "750,000" text in the field named "ItemListQuantity" of "ItemList" table
	* Link strings
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '1' | '45,000'   | 'Dress (XS/Blue)'  | 'Store 01' | 'pcs'  |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '520,00' | '45,000'   | 'Dress (XS/Blue)'  | 'pcs'  |
		And I click the button named "Link"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '750,000'  | 'Dress (S/Yellow)' | 'Store 01' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '550,00' | '750,000'  | 'Dress (S/Yellow)' | 'pcs'  |
		And I click the button named "Link"
		And I click "Ok" button
	* Check
		And "ItemList" table became equal
			| '#' | 'Price type'        | 'Item'  | 'Item key' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Quantity' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Other revenue type'   | 'Store'    | 'Use shipment confirmation' | 'Sales order'                                 |
			| '1' | 'Basic Price Types' | 'Dress' | 'XS/Blue'  | 'No'                 | '3 569,49'   | 'pcs'  | '45,000'   | '520,00' | '18%' | '19 830,51'  | '23 400,00'    | 'No'             | ''                     | 'Store 01' | 'Yes'                       | 'Sales order 1 051 dated 20.07.2021 10:44:11' |
			| '2' | 'Basic Price Types' | 'Dress' | 'S/Yellow' | 'No'                 | '62 923,73'  | 'pcs'  | '750,000'  | '550,00' | '18%' | '349 576,27' | '412 500,00'   | 'No'             | ''                     | 'Store 01' | 'Yes'                       | 'Sales order 1 051 dated 20.07.2021 10:44:11' |
		And I click "Post" button
		And I delete "$$SalesInvoice1051$$" variable
		And I delete "$$NumberSalesInvoice1051$$" variable
		And I save the window as "$$SalesInvoice1051$$" 
		And I save the value of "Number" field as "$$NumberSalesInvoice1051$$"
	* Create SR (Store 02)
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I select from the drop-down list named "Partner" by "Kalipso" string
		And I select from "Partner term" drop-down list by "Basic Partner terms, TRY" string
		And I select from "Store" drop-down list by "Store 02" string
		And I select from "Branch" drop-down list by "Front office" string
	* Filling in Item tab	
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Dress" from "Item" drop-down list by string in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select "XS/Blue" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select "dress" from "Item" drop-down list by string in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select "S/Yellow" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "11,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Link strings
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '1' | '10,000'   | 'Dress (XS/Blue)'  | 'Store 02' | 'pcs'  |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '520,00' | '45,000'   | 'Dress (XS/Blue)'  | 'pcs'  |
		And I click the button named "Link"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '11,000'   | 'Dress (S/Yellow)' | 'Store 02' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '550,00' | '750,000'  | 'Dress (S/Yellow)' | 'pcs'  |
		And I click the button named "Link"
		And I click "Ok" button
	* Check
		And "ItemList" table became equal
			| '#' | 'Item'  | 'Item key' | 'Tax amount' | 'Unit' | 'Sales invoice'        | 'Quantity' | 'Price'  | 'Net amount' | 'Use goods receipt' | 'Total amount' | 'Store'    | 'VAT' |
			| '1' | 'Dress' | 'XS/Blue'  | '793,22'     | 'pcs'  | '$$SalesInvoice1051$$' | '10,000'   | '520,00' | '4 406,78'   | 'No'                | '5 200,00'     | 'Store 02' | '18%' |
			| '2' | 'Dress' | 'S/Yellow' | '922,88'     | 'pcs'  | '$$SalesInvoice1051$$' | '11,000'   | '550,00' | '5 127,12'   | 'No'                | '6 050,00'     | 'Store 02' | '18%' |
		And for each line of "ItemList" table I do
			And I set "Use goods receipt" checkbox in "ItemList" table
		And I click "Post" button
		And I delete "$$SalesReturn1051$$" variable
		And I delete "$$NumberSalesReturn1051$$" variable
		And I save the window as "$$SalesReturn1051$$" 
		And I save the value of "Number" field as "$$NumberSalesReturn1051$$"
	* Create GR (Store 02)
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I select "Return from customer" exact value from "Transaction type" drop-down list
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from the drop-down list named "Partner" by "Kalipso" string
		And I select from "Store" drop-down list by "Store 02" string
		And I select from "Branch" drop-down list by "Front office" string
	* Filling in Item tab	
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Dress" from "Item" drop-down list by string in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select "XS/Blue" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select "dress" from "Item" drop-down list by string in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select "S/Yellow" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "11,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Link strings
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '1' | '10,000'   | 'Dress (XS/Blue)'  | 'Store 02' | 'pcs'  |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Row presentation' | 'Unit' |
			| '10,000'   | 'Dress (XS/Blue)'  | 'pcs'  |
		And I click the button named "Link"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '11,000'   | 'Dress (S/Yellow)' | 'Store 02' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Row presentation' | 'Unit' |
			| '11,000'   | 'Dress (S/Yellow)' | 'pcs'  |
		And I click the button named "Link"
		And I click "Ok" button
		And I click "Post" button
		And "ItemList" table became equal
			| '#' | 'Item'  | 'Item key' | 'Unit' | 'Store'    | 'Quantity' | 'Sales invoice'        | 'Receipt basis'       | 'Sales return'        |
			| '1' | 'Dress' | 'XS/Blue'  | 'pcs'  | 'Store 02' | '10,000'   | '$$SalesInvoice1051$$' | '$$SalesReturn1051$$' | '$$SalesReturn1051$$' |
			| '2' | 'Dress' | 'S/Yellow' | 'pcs'  | 'Store 02' | '11,000'   | '$$SalesInvoice1051$$' | '$$SalesReturn1051$$' | '$$SalesReturn1051$$' |
		And I delete "$$NumberGoodsReceipt1051$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt1051$$"
	* Unpost documents
		And I click "Cancel posting" button
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'                    |
			| '$$NumberSalesReturn1051$$' |
		And I click the button named "FormUndoPosting"
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                    |
			| '$$NumberSalesInvoice1051$$' |
		And I click the button named "FormUndoPosting"
		And I close all client application windows
				