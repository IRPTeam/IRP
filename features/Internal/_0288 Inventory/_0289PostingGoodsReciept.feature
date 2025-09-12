#language: en
@tree
@Positive
@Inventory

Feature: create document Goods receipt

As a storekeeper
I want to create a Goods receipt
To take products to the store

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _028900 preparation (Goods receipt)
	When set True value to the constant
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog BusinessUnits objects
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
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create information register CurrencyRates records
		When Create catalog TaxRates objects
		When Create catalog Partners objects
		When Create catalog Taxes objects
		When Create information register Taxes records (VAT)
	* Document Discount 
		When Create Document discount (for row)
		* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	When Create document PurchaseOrder objects (creation based on)
	When Create document PurchaseOrder and Purchase invoice objects (creation based on, PI >PO)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseOrder.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document SalesReturn objects (creation based on)
	And I execute 1C:Enterprise script at server
		| "Documents.SalesReturn.FindByNumber(351).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesReturn.FindByNumber(353).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesReturn.FindByNumber(354).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document SalesOrder and SalesInvoice objects (creation based on, SI >SO)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"    |
	When Create document SalesReturnOrder objects (creation based on)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesReturnOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"    |
	When Create document SalesReturn objects (creation based on, number32)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"    |
	When Create document PurchaseInvoice objects (linked)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);"   |
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
			| 'Number'   | 'Partner'    |
			| '102'      | 'Astar'      |
	And in the table "List" I click the button named "ListContextMenuPost"		
	* Save PI numbers
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '101'       |
		And I select current line in "List" table	
		And I delete "$$PurchaseInvoice2040005$$" variable
		And I delete "$$NumberPurchaseInvoice2040005$$" variable
		And I save the window as "$$PurchaseInvoice2040005$$"
		And I save the value of "Number" field as "$$NumberPurchaseInvoice2040005$$"
		And I close current window
		And I go to line in "List" table
			| 'Number'   | 'Partner'    |
			| '102'      | 'Astar'      |
		And I select current line in "List" table	
		And I delete "$$PurchaseInvoice20400051$$" variable
		And I delete "$$NumberPurchaseInvoice20400051$$" variable
		And I save the window as "$$PurchaseInvoice20400051$$"
		And I save the value of "Number" field as "$$NumberPurchaseInvoice20400051$$"
		And I close all client application windows
	* Check or create InventoryTransfer021030
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		If "List" table does not contain lines Then
				| "Number"                                |
				| "$$NumberInventoryTransfer021030$$"     |
			When create InventoryTransfer021030
		And I close all client application windows
		
Scenario: _0289001 check preparation
	When check preparation

Scenario: _028901 create document Goods Receipt based on Purchase invoice (with PO, PI>PO)
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'   | 'Partner'      |
			| '102'      | 'Ferron BP'    |
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		And "BasisesTree" table contains lines
			| 'Row presentation'                                 | 'Use'   | 'Quantity'   | 'Unit'             | 'Price'    | 'Currency'    |
			| 'Purchase order 102 dated 03.03.2021 08:59:33'     | 'Yes'   | ''           | ''                 | ''         | ''            |
			| 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'Yes'   | ''           | ''                 | ''         | ''            |
			| 'Dress (XS/Blue)'                                  | 'Yes'   | '1,000'      | 'pcs'              | '100,00'   | 'TRY'         |
			| 'Shirt (36/Red)'                                   | 'Yes'   | '12,000'     | 'pcs'              | '200,00'   | 'TRY'         |
			| 'Boots (37/18SD)'                                  | 'Yes'   | '2,000'      | 'Boots (12 pcs)'   | '300,00'   | 'TRY'         |
			| 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'Yes'   | ''           | ''                 | ''         | ''            |
			| 'Shirt (38/Black)'                                 | 'Yes'   | '2,000'      | 'pcs'              | '150,00'   | 'TRY'         |
		Then the number of "BasisesTree" table lines is "равно" "7"
		And I click "Ok" button
	* Create GR and check filling in
		And "ItemList" table contains lines
			| '#'   | 'Item'    | 'Inventory transfer'   | 'Item key'   | 'Store'      | 'Internal supply request'   | 'Quantity'   | 'Sales invoice'   | 'Unit'             | 'Receipt basis'                                    | 'Purchase invoice'                                 | 'Currency'   | 'Sales return order'   | 'Sales order'   | 'Purchase order'                                 | 'Inventory transfer order'   | 'Sales return'    |
			| '1'   | 'Dress'   | ''                     | 'XS/Blue'    | 'Store 02'   | ''                          | '1,000'      | ''                | 'pcs'              | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'TRY'        | ''                     | ''              | 'Purchase order 102 dated 03.03.2021 08:59:33'   | ''                           | ''                |
			| '2'   | 'Shirt'   | ''                     | '36/Red'     | 'Store 02'   | ''                          | '12,000'     | ''                | 'pcs'              | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'TRY'        | ''                     | ''              | 'Purchase order 102 dated 03.03.2021 08:59:33'   | ''                           | ''                |
			| '3'   | 'Boots'   | ''                     | '37/18SD'    | 'Store 02'   | ''                          | '2,000'      | ''                | 'Boots (12 pcs)'   | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'TRY'        | ''                     | ''              | 'Purchase order 102 dated 03.03.2021 08:59:33'   | ''                           | ''                |
			| '4'   | 'Shirt'   | ''                     | '38/Black'   | 'Store 02'   | ''                          | '2,000'      | ''                | 'pcs'              | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'TRY'        | ''                     | ''              | ''                                               | ''                           | ''                |
		Then the number of "ItemList" table lines is "равно" "4"
	* Check RowId info
		And I click "Show row key" button		
		And "RowIDInfo" table contains lines
			| '#'   | 'Key'   | 'Basis'                                            | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '1'   | '*'     | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'c9b5514d-364e-4712-bc66-6530bb6a9ec6'   | ''            | '1,000'      | '06d436b9-6ac6-493d-a81d-c1bef6c8597e'   | 'GR'             | 'c9b5514d-364e-4712-bc66-6530bb6a9ec6'    |
			| '2'   | '*'     | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | '216a343e-3f69-40e5-a386-381f2dc9ed5f'   | ''            | '12,000'     | '42409c7c-a984-4411-b165-752fe75fe0a8'   | 'GR'             | '216a343e-3f69-40e5-a386-381f2dc9ed5f'    |
			| '3'   | '*'     | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'cbb88d81-b47c-4350-a555-6ab883274a1a'   | ''            | '24,000'     | 'cd747541-4559-4543-ba36-1f5b79b24fef'   | 'GR'             | 'cbb88d81-b47c-4350-a555-6ab883274a1a'    |
			| '4'   | '*'     | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'e3824d62-3c37-47e7-8d3e-81f29986e69f'   | ''            | '2,000'      | 'e3824d62-3c37-47e7-8d3e-81f29986e69f'   | 'GR'             | 'e3824d62-3c37-47e7-8d3e-81f29986e69f'    |
		Then the number of "RowIDInfo" table lines is "равно" "4"
		And I close all client application windows
	


Scenario: _028902 create document Goods Receipt based on Purchase order (with PI, PI>PO)
	* Select PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '102'       |
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		And "BasisesTree" table contains lines
			| 'Row presentation'                                 | 'Use'   | 'Quantity'   | 'Unit'             | 'Price'    | 'Currency'    |
			| 'Purchase order 102 dated 03.03.2021 08:59:33'     | 'Yes'   | ''           | ''                 | ''         | ''            |
			| 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'Yes'   | ''           | ''                 | ''         | ''            |
			| 'Dress (XS/Blue)'                                  | 'Yes'   | '1,000'      | 'pcs'              | '100,00'   | 'TRY'         |
			| 'Shirt (36/Red)'                                   | 'Yes'   | '12,000'     | 'pcs'              | '200,00'   | 'TRY'         |
			| 'Boots (37/18SD)'                                  | 'Yes'   | '2,000'      | 'Boots (12 pcs)'   | '300,00'   | 'TRY'         |
		Then the number of "BasisesTree" table lines is "равно" "5"
		And I click "Ok" button
	* Create GR and check filling in
		And "ItemList" table contains lines
			| '#'   | 'Item'    | 'Inventory transfer'   | 'Item key'   | 'Store'      | 'Internal supply request'   | 'Quantity'   | 'Sales invoice'   | 'Unit'             | 'Receipt basis'                                    | 'Purchase invoice'                                 | 'Currency'   | 'Sales return order'   | 'Sales order'   | 'Purchase order'                                 | 'Inventory transfer order'   | 'Sales return'    |
			| '1'   | 'Dress'   | ''                     | 'XS/Blue'    | 'Store 02'   | ''                          | '1,000'      | ''                | 'pcs'              | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'TRY'        | ''                     | ''              | 'Purchase order 102 dated 03.03.2021 08:59:33'   | ''                           | ''                |
			| '2'   | 'Shirt'   | ''                     | '36/Red'     | 'Store 02'   | ''                          | '12,000'     | ''                | 'pcs'              | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'TRY'        | ''                     | ''              | 'Purchase order 102 dated 03.03.2021 08:59:33'   | ''                           | ''                |
			| '3'   | 'Boots'   | ''                     | '37/18SD'    | 'Store 02'   | ''                          | '2,000'      | ''                | 'Boots (12 pcs)'   | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'TRY'        | ''                     | ''              | 'Purchase order 102 dated 03.03.2021 08:59:33'   | ''                           | ''                |
		Then the number of "ItemList" table lines is "равно" "3"
	* Check RowId info
		And I click "Show row key" button		
		And "RowIDInfo" table contains lines
			| '#'   | 'Key'   | 'Basis'                                            | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '1'   | '*'     | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'c9b5514d-364e-4712-bc66-6530bb6a9ec6'   | ''            | '1,000'      | '06d436b9-6ac6-493d-a81d-c1bef6c8597e'   | 'GR'             | 'c9b5514d-364e-4712-bc66-6530bb6a9ec6'    |
			| '2'   | '*'     | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | '216a343e-3f69-40e5-a386-381f2dc9ed5f'   | ''            | '12,000'     | '42409c7c-a984-4411-b165-752fe75fe0a8'   | 'GR'             | '216a343e-3f69-40e5-a386-381f2dc9ed5f'    |
			| '3'   | '*'     | 'Purchase invoice 102 dated 03.03.2021 09:25:04'   | 'cbb88d81-b47c-4350-a555-6ab883274a1a'   | ''            | '24,000'     | 'cd747541-4559-4543-ba36-1f5b79b24fef'   | 'GR'             | 'cbb88d81-b47c-4350-a555-6ab883274a1a'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt028901$$" variable
		And I delete "$$GoodsReceipt028901$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt028901$$"
		And I save the window as "$$GoodsReceipt028901$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberGoodsReceipt028901$$'    |
		And I close all client application windows

Scenario: _028905 create document Goods Receipt based on Inventory transfer
	* Add items from basis documents
		* Open form for create GR
			Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
			And I click the button named "FormCreate"
		* Filling in the main details of the document
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 03'        |
			And I select current line in "List" table
			And I select "Inventory transfer" exact value from "Transaction type" drop-down list
		* Select items from basis documents
			And I click the button named "AddBasisDocuments"
			And I go to line in "BasisesTree" table
				| 'Quantity'    | 'Row presentation'    | 'Unit'    | 'Use'     |
				| '3,000'       | 'Dress (L/Green)'     | 'pcs'     | 'No'      |
			And I change "Use" checkbox in "BasisesTree" table
			And I finish line editing in "BasisesTree" table
			And I click "Ok" button
			And I click "Show row key" button	
			And in the table "ItemList" I click "Edit quantity in base unit" button			
		* Check Item tab and RowID tab
			And "ItemList" table contains lines
				| 'Store'       | '#'    | 'Stock quantity'    | 'Item'     | 'Inventory transfer'             | 'Item key'    | 'Quantity'    | 'Sales invoice'    | 'Unit'    | 'Receipt basis'                  | 'Purchase invoice'    | 'Currency'    | 'Sales return order'    | 'Sales order'    | 'Purchase order'    | 'Inventory transfer order'    | 'Sales return'     |
				| 'Store 03'    | '1'    | '3,000'             | 'Dress'    | '$$InventoryTransfer021030$$'    | 'L/Green'     | '3,000'       | ''                 | 'pcs'     | '$$InventoryTransfer021030$$'    | ''                    | ''            | ''                      | ''               | ''                  | ''                            | ''                 |
			And "RowIDInfo" table contains lines
				| 'Basis'                          | 'Next step'    | 'Quantity'    | 'Current step'     |
				| '$$InventoryTransfer021030$$'    | ''             | '3,000'       | 'GR'               |
		And I close all client application windows
	* Create document Goods Receipt based on Inventory transfer (Create button)
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'                               |
			| '$$NumberInventoryTransfer021030$$'    |
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button	
		And Delay 1
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Inventory transfer"
		Then the form attribute named "Store" became equal to "Store 03"
		And "ItemList" table contains lines
			| '#'   | 'Item'    | 'Inventory transfer'            | 'Item key'   | 'Quantity'   | 'Sales invoice'   | 'Unit'   | 'Store'      | 'Receipt basis'                  |
			| '1'   | 'Dress'   | '$$InventoryTransfer021030$$'   | 'L/Green'    | '3,000'      | ''                | 'pcs'    | 'Store 03'   | '$$InventoryTransfer021030$$'    |
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1GoodsReceipt028905$$"	
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#'   | 'Key'                          | 'Basis'                         | 'Row ID'   | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'    |
			| '1'   | '$$Rov1GoodsReceipt028905$$'   | '$$InventoryTransfer021030$$'   | '*'        | ''            | '3,000'      | '*'           | 'GR'             | '*'          |
		Then the number of "RowIDInfo" table lines is "равно" "1"
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt028905$$" variable
		And I delete "$$GoodsReceipt028905$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt028905$$"
		And I save the window as "$$GoodsReceipt028905$$"
		And I click the button named "FormPostAndClose"
		


Scenario: _028930 check link/unlink form in the GR
	* Open form for create GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I select "Purchase" exact value from "Transaction type" drop-down list
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Crystal'        |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Company Adel'    |
		And I select current line in "List" table
	* Select items from basis documents
		And I click the button named "AddBasisDocuments"
		And I expand current line in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'      | 'Quantity'   | 'Row presentation'   | 'Unit'             | 'Use'    |
			| 'TRY'        | '8 400,00'   | '2,000'      | 'Boots (36/18SD)'    | 'Boots (12 pcs)'   | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '10,000'     | 'Dress (M/White)'    | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'       | 'Unit'   | 'Use'    |
			| 'TRY'        | '400,00'   | '15,000'     | 'Trousers (36/Yellow)'   | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Show row key" button
	* Check RowIDInfo
		And "RowIDInfo" table contains lines
		| '#'  | 'Basis'                                           | 'Next step'  | 'Quantity'  | 'Current step'   |
		| '1'  | 'Purchase invoice 101 dated 05.03.2021 12:14:08'  | ''           | '10,000'    | 'GR'             |
		| '2'  | 'Purchase invoice 101 dated 05.03.2021 12:14:08'  | ''           | '15,000'    | 'GR'             |
		| '3'  | 'Purchase invoice 101 dated 05.03.2021 12:14:08'  | ''           | '24,000'    | 'GR'             |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Unlink line
		And I click the button named "LinkUnlinkBasisDocuments"
		And I go to line in "ItemListRows" table
			| '#'   | 'Quantity'   | 'Row presentation'   | 'Store'      | 'Unit'              |
			| '3'   | '2,000'      | 'Boots (36/18SD)'    | 'Store 02'   | 'Boots (12 pcs)'    |
		And I set checkbox "Linked documents"
		And I go to line in "ResultsTree" table
			| 'Currency'   | 'Price'      | 'Quantity'   | 'Row presentation'   | 'Unit'              |
			| 'TRY'        | '8 400,00'   | '2,000'      | 'Boots (36/18SD)'    | 'Boots (12 pcs)'    |
		And I click "Unlink" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Purchase invoice'                                  |
			| 'Dress'      | 'M/White'     | 'Purchase invoice 101 dated 05.03.2021 12:14:08'    |
			| 'Trousers'   | '36/Yellow'   | 'Purchase invoice 101 dated 05.03.2021 12:14:08'    |
			| 'Boots'      | '36/18SD'     | ''                                                  |
	* Link line
		And I click the button named "LinkUnlinkBasisDocuments"
		And I go to line in "ItemListRows" table
			| '#'   | 'Quantity'   | 'Row presentation'   | 'Store'      | 'Unit'              |
			| '3'   | '2,000'      | 'Boots (36/18SD)'    | 'Store 02'   | 'Boots (12 pcs)'    |
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                                  |
			| 'Purchase invoice 101 dated 05.03.2021 12:14:08'    |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'      | 'Quantity'   | 'Row presentation'   | 'Unit'              |
			| 'TRY'        | '8 400,00'   | '2,000'      | 'Boots (36/18SD)'    | 'Boots (12 pcs)'    |
		And I click "Link" button
		And I click "Ok" button
		And "RowIDInfo" table contains lines
			| '#'   | 'Basis'                                            | 'Next step'   | 'Quantity'   | 'Current step'    |
			| '1'   | 'Purchase invoice 101 dated 05.03.2021 12:14:08'   | ''            | '10,000'     | 'GR'              |
			| '2'   | 'Purchase invoice 101 dated 05.03.2021 12:14:08'   | ''            | '15,000'     | 'GR'              |
			| '3'   | 'Purchase invoice 101 dated 05.03.2021 12:14:08'   | ''            | '24,000'     | 'GR'              |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Purchase invoice'                                  |
			| 'Dress'      | 'M/White'     | 'Purchase invoice 101 dated 05.03.2021 12:14:08'    |
			| 'Trousers'   | '36/Yellow'   | 'Purchase invoice 101 dated 05.03.2021 12:14:08'    |
			| 'Boots'      | '36/18SD'     | 'Purchase invoice 101 dated 05.03.2021 12:14:08'    |
	* Delete string, add it again, change unit
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Store'       |
			| 'Boots'   | '36/18SD'    | '2,000'      | 'Store 02'    |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "AddBasisDocuments"
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'      | 'Quantity'   | 'Row presentation'   | 'Unit'             | 'Use'    |
			| 'TRY'        | '8 400,00'   | '2,000'      | 'Boots (36/18SD)'    | 'Boots (12 pcs)'   | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Purchase invoice'                                  |
			| 'Dress'      | 'M/White'     | 'Purchase invoice 101 dated 05.03.2021 12:14:08'    |
			| 'Trousers'   | '36/Yellow'   | 'Purchase invoice 101 dated 05.03.2021 12:14:08'    |
			| 'Boots'      | '36/18SD'     | 'Purchase invoice 101 dated 05.03.2021 12:14:08'    |
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Store'       |
			| 'Boots'   | '36/18SD'    | '2,000'      | 'Store 02'    |
		And I activate "Unit" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		And "RowIDInfo" table contains lines
			| 'Basis'                                            | 'Next step'   | 'Quantity'    |
			| 'Purchase invoice 101 dated 05.03.2021 12:14:08'   | ''            | '10,000'      |
			| 'Purchase invoice 101 dated 05.03.2021 12:14:08'   | ''            | '15,000'      |
			| 'Purchase invoice 101 dated 05.03.2021 12:14:08'   | ''            | '2,000'       |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I close all client application windows


Scenario: _028903 create document Goods Receipt based on Sales return (Create button)
	* Select SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		And "BasisesTree" table contains lines
			| 'Row presentation'                            | 'Use'   | 'Quantity'   | 'Unit'             | 'Price'      | 'Currency'    |
			| 'Sales return 32 dated 24.03.2021 14:27:53'   | 'Yes'   | ''           | ''                 | ''           | ''            |
			| 'Dress (XS/Blue)'                             | 'Yes'   | '1,000'      | 'pcs'              | '520,00'     | 'TRY'         |
			| 'Boots (37/18SD)'                             | 'Yes'   | '2,000'      | 'Boots (12 pcs)'   | '8 400,00'   | 'TRY'         |
		Then the number of "BasisesTree" table lines is "равно" "3"
		And I click "Ok" button
	* Create GR and check filling in
		And "ItemList" table contains lines
			| 'Item'    | 'Inventory transfer'   | 'Item key'   | 'Store'      | 'Internal supply request'   | 'Quantity'   | 'Sales invoice'                                | 'Unit'             | 'Receipt basis'                               | 'Purchase invoice'   | 'Currency'   | 'Sales return order'                                | 'Sales order'   | 'Purchase order'   | 'Inventory transfer order'   | 'Sales return'                                 |
			| 'Dress'   | ''                     | 'XS/Blue'    | 'Store 02'   | ''                          | '1,000'      | 'Sales invoice 32 dated 04.03.2021 16:32:23'   | 'pcs'              | 'Sales return 32 dated 24.03.2021 14:27:53'   | ''                   | 'TRY'        | 'Sales return order 32 dated 23.03.2021 15:23:31'   | ''              | ''                 | ''                           | 'Sales return 32 dated 24.03.2021 14:27:53'    |
			| 'Boots'   | ''                     | '37/18SD'    | 'Store 02'   | ''                          | '2,000'      | 'Sales invoice 32 dated 04.03.2021 16:32:23'   | 'Boots (12 pcs)'   | 'Sales return 32 dated 24.03.2021 14:27:53'   | ''                   | 'TRY'        | 'Sales return order 32 dated 23.03.2021 15:23:31'   | ''              | ''                 | ''                           | 'Sales return 32 dated 24.03.2021 14:27:53'    |
		Then the number of "ItemList" table lines is "равно" "2"
	* Check RowId info
		And I click "Show row key" button	
		And I go to line in "ItemList" table
		| '#'   |
		| '1'   |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1GoodsReceipt028903$$" variable
		And I save the current field value as "$$Rov1GoodsReceipt028903$$"
		And I go to line in "ItemList" table
		| '#'   |
		| '2'   |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2GoodsReceipt028903$$" variable
		And I save the current field value as "$$Rov2GoodsReceipt028903$$"		
		And "RowIDInfo" table contains lines
			| '#'   | 'Key'                          | 'Basis'                                       | 'Row ID'   | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'    |
			| '1'   | '$$Rov1GoodsReceipt028903$$'   | 'Sales return 32 dated 24.03.2021 14:27:53'   | '*'        | ''            | '1,000'      | '*'           | 'GR'             | '*'          |
			| '2'   | '$$Rov2GoodsReceipt028903$$'   | 'Sales return 32 dated 24.03.2021 14:27:53'   | '*'        | ''            | '24,000'     | '*'           | 'GR'             | '*'          |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt028901$$" variable
		And I delete "$$GoodsReceipt028901$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt028901$$"
		And I save the window as "$$GoodsReceipt028901$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows


Scenario: _028931 check link/unlink form in the GR (Sales return)
	* Open form for create GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I select "Return from customer" exact value from "Transaction type" drop-down list
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table		
	* Select items from basis documents
		And I click the button named "AddBasisDocuments"		
		And "BasisesTree" table became equal
			| 'Row presentation'                             | 'Use'   | 'Quantity'   | 'Unit'                     | 'Price'      | 'Currency'    |
			| 'Sales return 351 dated 24.03.2021 14:04:08'   | 'No'    | ''           | ''                         | ''           | ''            |
			| 'High shoes (39/19SD)'                         | 'No'    | '10,000'     | 'High shoes box (8 pcs)'   | '4 000,00'   | 'TRY'         |
			| 'Bag (ODS)'                                    | 'No'    | '20,000'     | 'pcs'                      | '200,00'     | 'TRY'         |
			| 'High shoes (39/19SD)'                         | 'No'    | '10,000'     | 'High shoes box (8 pcs)'   | '4 000,00'   | 'TRY'         |
			| 'Sales return 353 dated 24.03.2021 14:10:41'   | 'No'    | ''           | ''                         | ''           | ''            |
			| 'High shoes (39/19SD)'                         | 'No'    | '10,000'     | 'High shoes box (8 pcs)'   | '4 000,00'   | 'TRY'         |
			| 'Bag (ODS)'                                    | 'No'    | '20,000'     | 'pcs'                      | '200,00'     | 'TRY'         |
			| 'High shoes (39/19SD)'                         | 'No'    | '10,000'     | 'High shoes box (8 pcs)'   | '4 000,00'   | 'TRY'         |
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'      | 'Quantity'   | 'Row presentation'       | 'Unit'                     | 'Use'    |
			| 'TRY'        | '4 000,00'   | '10,000'     | 'High shoes (39/19SD)'   | 'High shoes box (8 pcs)'   | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '200,00'   | '20,000'     | 'Bag (ODS)'          | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#'   | 'Item'         | 'Item key'   | 'Store'      | 'Quantity'   | 'Unit'                     | 'Receipt basis'                                | 'Purchase invoice'   | 'Currency'   | 'Sales return order'   | 'Purchase order'   | 'Inventory transfer order'   | 'Sales return'                                  |
			| '1'   | 'High shoes'   | '39/19SD'    | 'Store 03'   | '10,000'     | 'High shoes box (8 pcs)'   | 'Sales return 351 dated 24.03.2021 14:04:08'   | ''                   | 'TRY'        | ''                     | ''                 | ''                           | 'Sales return 351 dated 24.03.2021 14:04:08'    |
			| '2'   | 'Bag'          | 'ODS'        | 'Store 03'   | '20,000'     | 'pcs'                      | 'Sales return 351 dated 24.03.2021 14:04:08'   | ''                   | 'TRY'        | ''                     | ''                 | ''                           | 'Sales return 351 dated 24.03.2021 14:04:08'    |
	* Unlink line and link it again
		And I click the button named "LinkUnlinkBasisDocuments"
		And I go to line in "ItemListRows" table
			| '#'   | 'Quantity'   | 'Row presentation'   | 'Store'      | 'Unit'    |
			| '2'   | '20,000'     | 'Bag (ODS)'          | 'Store 03'   | 'pcs'     |
		And I set checkbox "Linked documents"
		And I go to line in "ResultsTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'    |
			| 'TRY'        | '200,00'   | '20,000'     | 'Bag (ODS)'          | 'pcs'     |
		And I click "Unlink" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#' | 'Item'       | 'Item key' | 'Store'    | 'Quantity' | 'Unit'                   | 'Receipt basis'                              | 'Purchase invoice' | 'Currency' | 'Sales return order' | 'Purchase order' | 'Inventory transfer order' | 'Sales return'                               |
			| '1' | 'High shoes' | '39/19SD'  | 'Store 03' | '10,000'   | 'High shoes box (8 pcs)' | 'Sales return 351 dated 24.03.2021 14:04:08' | ''                 | 'TRY'      | ''                   | ''               | ''                         | 'Sales return 351 dated 24.03.2021 14:04:08' |
			| '2' | 'Bag'        | 'ODS'      | 'Store 03' | '20,000'   | 'pcs'                    | ''                                           | ''                 | ''         | ''                   | ''               | ''                         | ''                                           |
		And I click the button named "LinkUnlinkBasisDocuments"
		And I go to line in "ItemListRows" table
			| '#'   | 'Quantity'   | 'Row presentation'   | 'Store'      | 'Unit'    |
			| '2'   | '20,000'     | 'Bag (ODS)'          | 'Store 03'   | 'pcs'     |
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                              |
			| 'Sales return 351 dated 24.03.2021 14:04:08'    |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'    |
			| 'TRY'        | '200,00'   | '20,000'     | 'Bag (ODS)'          | 'pcs'     |
		And I click "Link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#' | 'Item'       | 'Item key' | 'Store'    | 'Quantity' | 'Unit'                   | 'Receipt basis'                              | 'Purchase invoice' | 'Currency' | 'Sales return order' | 'Purchase order' | 'Inventory transfer order' | 'Sales return'                               |
			| '1' | 'High shoes' | '39/19SD'  | 'Store 03' | '10,000'   | 'High shoes box (8 pcs)' | 'Sales return 351 dated 24.03.2021 14:04:08' | ''                 | 'TRY'      | ''                   | ''               | ''                         | 'Sales return 351 dated 24.03.2021 14:04:08' |
			| '2' | 'Bag'        | 'ODS'      | 'Store 03' | '20,000'   | 'pcs'                    | 'Sales return 351 dated 24.03.2021 14:04:08' | ''                 | 'TRY'      | ''                   | ''               | ''                         | 'Sales return 351 dated 24.03.2021 14:04:08' |
		And I close all client application windows
		
Scenario: _028932 cancel line in the PO and create GR
	* Cancel line in the PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '217'       |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| '#'   | 'Item'      | 'Item key'   | 'Quantity'    |
			| '2'   | 'Service'   | 'Internet'   | '2,000'       |
		And I activate "Cancel" field in "ItemList" table
		And I set "Cancel" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Cancel reason" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Cancel reason" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'      |
			| 'not available'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post" button			
	* Create GR
		And I click "Goods receipt" button
		Then "Add linked document rows" window is opened
		And "BasisesTree" table does not contain lines
			| 'Row presentation'     | 'Quantity'   | 'Unit'    |
			| 'Service (Internet)'   | '2,000'      | 'pcs'     |
		And I close all client application windows	
				


Scenario: _300507 check connection to GoodsReceipt report "Related documents"
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	* Form report Related documents
		And I go to line in "List" table
		| 'Number'                         |
		| '$$NumberGoodsReceipt028901$$'   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "* Related documents" window is opened
	And I close all client application windows
