#language: en
@tree
@Positive
@Forms

Feature: mobile forms

Background:
	Given I launch TestClient opening script or connect the existing one

	
Scenario: _0156000 preparation
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog Countries objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog Companies objects (own Second company)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BusinessUnits objects
		When Create catalog Partners objects
		When Create catalog Partners objects (Kalipso)
		When Create catalog InterfaceGroups objects (Purchase and production,  Main information)
		When Create catalog ObjectStatuses objects
		When Create catalog Units objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog ItemTypes objects
		When Create catalog Items objects
		When Create catalog ItemKeys objects
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
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog SerialLotNumbers objects
		When Create catalog PaymentTerminals objects
		When Create catalog RetailCustomers objects
		When Create catalog SerialLotNumbers objects
		When Create catalog PaymentTerminals objects
		When Create catalog RetailCustomers objects
		When Create catalog BankTerms objects
		When Create catalog SpecialOfferRules objects (Test)
		When Create catalog SpecialOfferTypes objects (Test)
		When Create catalog SpecialOffers objects (Test)
		When Create catalog CashStatementStatuses objects (Test)
		When Create catalog Hardware objects  (Test)
		When Create catalog Workstations objects  (Test)
		When Create catalog ItemSegments objects
		When Create information register Barcodes records
		When Create catalog PaymentTypes objects
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
		And Delay 10
	* Import documents
		When Create document InventoryTransfer objects (stock control)
		When Create document InventoryTransferOrder objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransferOrder.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.InventoryTransferOrder.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.InventoryTransferOrder.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document InventoryTransfer objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransfer.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.InventoryTransfer.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.InventoryTransfer.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.InventoryTransfer.FindByNumber(203).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.InventoryTransfer.FindByNumber(204).GetObject().Write(DocumentWriteMode.Posting);" |


Scenario: _0156010 Store keeper workspace (create GR)
	Given I open hyperlink "e1cib/app/DataProcessor.StoreKeeperWorkspace"
	* Scan first Item
		And I click "SearchByBarcode" button
		Then "Enter a barcode" window is opened
		And I input "2202283713" text in the field named "InputFld"
		And I click the button named "OK"
		And "GoodsInTransitIncoming" table became equal
			| 'Number' | 'Date'       | 'Quantity' |
			| '21'     | '01.03.2021' | '10,000'   |
			| '203'    | '01.03.2021' | '10,000'   |
			| '202'    | '01.03.2021' | '10,000'   |
		And I input "7,000" text in the field named "Quantity"
		And the editing text of form attribute named "Quantity" became equal to "7,000"
		Then the form attribute named "Unit" became equal to "pcs"
		And I go to line in "GoodsInTransitIncoming" table
			| 'Number' |
			| '202'    |
	* Create GR
		And I click "Create Goods receipt" button
		Then "DocGoodsReceipt" form attribute became equal to "Goods receipt*" template
		And I click the hyperlink named "DocGoodsReceipt"
		And "ItemList" table contains lines
			| 'Inventory transfer'                               | 'Item'  | 'Item key' | 'Store'    | 'Quantity' | 'Unit' | 'Receipt basis'                                    |
			| 'Inventory transfer 202 dated 01.03.2021 10:05:10' | 'Dress' | 'S/Yellow' | 'Store 03' | '7,000'    | 'pcs'  | 'Inventory transfer 202 dated 01.03.2021 10:05:10' |
		And I close all client application windows
		
Scenario: _0156012 Store keeper workspace (try create GR without IT)	
	And I close all client application windows
	Given I open hyperlink "e1cib/app/DataProcessor.StoreKeeperWorkspace"
	* Scan item
		And I click "Input barcode" button
		And I input "2202283739" text in the field named "InputFld"
		And I click the button named "OK"	
		And I input "5,000" text in the field named "Quantity"
		And the editing text of form attribute named "Quantity" became equal to "5,000"
		Then the form attribute named "Unit" became equal to "pcs"
		Then the number of "GoodsInTransitIncoming" table lines is "равно" 0
	* Try create GR
		And I click "Create Goods receipt" button	
		Then there are lines in TestClient message log
			|'Select any production planing'|
		And I close all client application windows


Scenario: _0156050 check items in the document by scan barcode
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	* Select IT
		And I go to line in "List" table
			| 'Number' |
			| '204'    |	
		And I select current line in "List" table
	* Open scan barcode form
		And I click the button named "OpenScanForm"
		And "ItemList" table became equal
			| 'Item'     | '#' | 'Item key'  | 'Unit' | 'Quantity' | 'Scanned' |
			| 'Dress'    | '1' | 'S/Yellow'  | 'pcs'  | '10,000'   | ''        |
			| 'Dress'    | '2' | 'XS/Blue'   | 'pcs'  | '10,000'   | ''        |
			| 'Trousers' | '3' | '36/Yellow' | 'pcs'  | '2,000'    | ''        |
			| 'Shirt'    | '4' | '36/Red'    | 'pcs'  | '15,000'   | ''        |
	* Scan Items
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "2202283713" text in the field named "InputFld"
		And I click the button named "OK"
		Then "Row form" window is opened
		And I input "9,000" text in "You scan" field
		And I move to the next attribute	
		And "ItemList" table became equal
			| 'Item'     | '#' | 'Item key'  | 'Unit' | 'Quantity' | 'Scanned' |
			| 'Dress'    | '1' | 'S/Yellow'  | 'pcs'  | '10,000'   | '9,000'   |
			| 'Dress'    | '2' | 'XS/Blue'   | 'pcs'  | '10,000'   | ''        |
			| 'Trousers' | '3' | '36/Yellow' | 'pcs'  | '2,000'    | ''        |
			| 'Shirt'    | '4' | '36/Red'    | 'pcs'  | '15,000'   | ''        |
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "2202283739" text in the field named "InputFld"
		And I click the button named "OK"
		Then "Row form" window is opened
		And I input "7,000" text in "You scan" field
		And I move to the next attribute
		And "ItemList" table became equal
			| 'Item'     | '#' | 'Item key'  | 'Unit' | 'Quantity' | 'Scanned' |
			| 'Dress'    | '1' | 'S/Yellow'  | 'pcs'  | '10,000'   | '9,000'   |
			| 'Dress'    | '2' | 'XS/Blue'   | 'pcs'  | '10,000'   | ''        |
			| 'Trousers' | '3' | '36/Yellow' | 'pcs'  | '2,000'    | ''        |
			| 'Shirt'    | '4' | '36/Red'    | 'pcs'  | '15,000'   | ''        |
			| 'Dress'    | '5' | 'L/Green'   | 'pcs'  | ''         | '7,000'   |
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "2202283713" text in the field named "InputFld"
		And I click the button named "OK"
		Then "Row form" window is opened
		And I input "1,000" text in "You scan" field
		And I move to the next attribute	
		And "ItemList" table became equal
			| 'Item'     | '#' | 'Item key'  | 'Unit' | 'Quantity' | 'Scanned' |
			| 'Dress'    | '1' | 'S/Yellow'  | 'pcs'  | '10,000'   | '10,000'  |
			| 'Dress'    | '2' | 'XS/Blue'   | 'pcs'  | '10,000'   | ''        |
			| 'Trousers' | '3' | '36/Yellow' | 'pcs'  | '2,000'    | ''        |
			| 'Shirt'    | '4' | '36/Red'    | 'pcs'  | '15,000'   | ''        |
			| 'Dress'    | '5' | 'L/Green'   | 'pcs'  | ''         | '7,000'   |
		And I click "Done" button
	* Check itemlist tab
		And "ItemList" table contains lines
			| '#' | 'Item'  | 'Item key' | 'Quantity' | 'Unit' | 'Inventory transfer order' |
			| '1' | 'Dress' | 'S/Yellow' | '10,000'   | 'pcs'  | ''                         |
			| '2' | 'Dress' | 'L/Green'  | '7,000'    | 'pcs'  | ''                         |
		And I close all client application windows
		
		
		
						
		
				
		


		
				
		
				


		
				

	
		
				


		
		
				
		
				
	
		
				
	
	