#language: en
@tree
@Positive
@PlannedReceiptReservation

Functionality: planned receipt reservation



Scenario: _0242000 preparation (planned receipt reservation)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
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
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects
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
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)
	* Tax settings
		When filling in Tax settings for company
		When Create document SalesOrder objects (SI before SC, not Use shipment sheduling)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(31).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create document SalesOrder objects (check reservation)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1081).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesOrder.FindByNumber(1082).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create document PlannedReceiptReservation objects (check reservation)
	And I execute 1C:Enterprise script at server
			| "Documents.PlannedReceiptReservation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create document PurchaseOrder, PurchaseInvoice, GoodsReceipt objects (check reservation)
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(31).GetObject().Write(DocumentWriteMode.Posting);" |
			

Scenario: _0242001 create planned receipt reservation based on SO
	* Select SO
		Given I open hyperlink 'e1cib/list/Document.SalesOrder'
		And I go to line in "List" table
			| 'Number' |
			| '1 082'  |
		And I click the button named "FormDocumentPlannedReceiptReservationGenerate"
		And I click "Ok" button
	* Filling in items tab
		And I click Select button of "Store (incoming)" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| '#' | 'Item'  | 'Item key' | 'Unit' | 'Store (requester)' | 'Quantity' | 'Incoming document' |
			| '1' | 'Shirt' | '36/Red'   | 'pcs'  | 'Store 02'          | '10,000'   | ''                  |
		And I select current line in "ItemList" table
		And I click choice button of "Incoming document" attribute in "ItemList" table
		And I go to line in "" table
			| ''               |
			| 'Purchase order' |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Number' |
			| '31'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I input "01.09.2021 00:00:00" text in the field named "Date"
		And I activate field named "ItemListLineNumber" in "ItemList" table	
		And I click the button named "FormPost"
		And I delete "$$NumberPlannedReceiptReservation0242001$$" variable
		And I delete "$$PlannedReceiptReservation0242001$$" variable
		And I save the value of "Number" field as "$$NumberPlannedReceiptReservation0242001$$"
		And I save the window as "$$PlannedReceiptReservation0242001$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
		And "List" table contains lines
			| 'Number'                |
			| '$$NumberPlannedReceiptReservation0242001$$' |
		And I close all client application windows

Scenario: _0242005 check reservation (SO-Planned reservation - PO - GR-PI/PI-GR)
	* Post documents
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.GoodsReceipt.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.GoodsReceipt.FindByNumber(33).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.GoodsReceipt.FindByNumber(34).GetObject().Write(DocumentWriteMode.Posting);" |
	* Check R4035B_IncomingStocks
		Given I open hyperlink "e1cib/list/AccumulationRegister.R4035B_IncomingStocks"
		And "List" table contains lines
			| 'Period'              | 'Recorder'                                                | 'Line number' | 'Store'    | 'Item key' | 'Order'                                       | 'Quantity' |
			| '08.02.2021 15:11:30' | 'Purchase order 31 dated 08.02.2021 15:11:30'             | '1'           | 'Store 02' | '36/Red'   | 'Purchase order 31 dated 08.02.2021 15:11:30' | '30,000'   |
			| '08.02.2021 15:11:30' | 'Purchase order 31 dated 08.02.2021 15:11:30'             | '2'           | 'Store 02' | '38/18SD'  | 'Purchase order 31 dated 08.02.2021 15:11:30' | '50,000'   |
			| '08.02.2021 15:11:30' | 'Purchase order 31 dated 08.02.2021 15:11:30'             | '3'           | 'Store 02' | 'XS/Blue'  | 'Purchase order 31 dated 08.02.2021 15:11:30' | '50,000'   |
			| '01.09.2021 00:00:00' | 'Planned receipt reservation 3 dated 01.09.2021 00:00:00' | '1'           | 'Store 02' | '36/Red'   | 'Purchase order 31 dated 08.02.2021 15:11:30' | '10,000'   |
			| '01.09.2021 12:00:00' | 'Planned receipt reservation 2 dated 01.09.2021 12:00:00' | '1'           | 'Store 02' | '36/Red'   | 'Purchase order 31 dated 08.02.2021 15:11:30' | '4,000'    |
			| '01.09.2021 12:00:00' | 'Planned receipt reservation 2 dated 01.09.2021 12:00:00' | '2'           | 'Store 02' | 'XS/Blue'  | 'Purchase order 31 dated 08.02.2021 15:11:30' | '8,000'    |
			| '14.09.2021 10:26:02' | 'Goods receipt 32 dated 14.09.2021 10:26:02'              | '1'           | 'Store 02' | '36/Red'   | 'Purchase order 31 dated 08.02.2021 15:11:30' | '1,000'    |
			| '14.09.2021 10:31:48' | 'Goods receipt 34 dated 14.09.2021 10:31:48'              | '1'           | 'Store 02' | 'XS/Blue'  | 'Purchase order 31 dated 08.02.2021 15:11:30' | '42,000'   |
		Then the number of "List" table lines is "равно" "8"
	* Check R4035B_IncomingStocks	
		Given I open hyperlink "e1cib/list/AccumulationRegister.R4036B_IncomingStocksRequested"
		And "List" table contains lines
			| 'Period'              | 'Recorder'                                                | 'Line number' | 'Incoming store' | 'Requester store' | 'Item key' | 'Order'                                       | 'Requester'                                   | 'Quantity' |
			| '01.09.2021 00:00:00' | 'Planned receipt reservation 3 dated 01.09.2021 00:00:00' | '1'           | 'Store 02'       | 'Store 02'        | '36/Red'   | 'Purchase order 31 dated 08.02.2021 15:11:30' | 'Sales order 31 dated 27.01.2021 19:50:45'    | '10,000'   |
			| '01.09.2021 12:00:00' | 'Planned receipt reservation 2 dated 01.09.2021 12:00:00' | '1'           | 'Store 02'       | 'Store 02'        | '36/Red'   | 'Purchase order 31 dated 08.02.2021 15:11:30' | 'Sales order 1 081 dated 28.01.2021 10:10:29' | '4,000'    |
			| '14.09.2021 10:26:02' | 'Goods receipt 32 dated 14.09.2021 10:26:02'              | '1'           | 'Store 02'       | 'Store 02'        | '36/Red'   | 'Purchase order 31 dated 08.02.2021 15:11:30' | 'Sales order 31 dated 27.01.2021 19:50:45'    | '10,000'   |
			| '14.09.2021 10:26:02' | 'Goods receipt 32 dated 14.09.2021 10:26:02'              | '2'           | 'Store 02'       | 'Store 02'        | '36/Red'   | 'Purchase order 31 dated 08.02.2021 15:11:30' | 'Sales order 1 081 dated 28.01.2021 10:10:29' | '4,000'    |
		Then the number of "List" table lines is "равно" "4"
	*  Check R4011B_FreeStocks
		Given I open hyperlink "e1cib/list/AccumulationRegister.R4011B_FreeStocks"
		And "List" table contains lines
			| 'Period'              | 'Recorder'                                   | 'Line number' | 'Store'    | 'Item key' | 'Quantity' |
			| '14.09.2021 10:26:02' | 'Goods receipt 32 dated 14.09.2021 10:26:02' | '1'           | 'Store 02' | '36/Red'   | '10,000'   |
			| '14.09.2021 10:26:02' | 'Goods receipt 32 dated 14.09.2021 10:26:02' | '2'           | 'Store 02' | '36/Red'   | '5,000'    |
			| '14.09.2021 10:26:02' | 'Goods receipt 32 dated 14.09.2021 10:26:02' | '3'           | 'Store 02' | '36/Red'   | '10,000'   |
			| '14.09.2021 10:26:02' | 'Goods receipt 32 dated 14.09.2021 10:26:02' | '4'           | 'Store 02' | '36/Red'   | '4,000'    |
	* Check R4010B_ActualStocks
		Given I open hyperlink "e1cib/list/AccumulationRegister.R4010B_ActualStocks"
		And "List" table contains lines
			| 'Period'              | 'Recorder'                                   | 'Line number' | 'Store'    | 'Item key' | 'Quantity' |
			| '14.09.2021 10:26:02' | 'Goods receipt 32 dated 14.09.2021 10:26:02' | '1'           | 'Store 02' | '36/Red'   | '10,000'   |
			| '14.09.2021 10:26:02' | 'Goods receipt 32 dated 14.09.2021 10:26:02' | '2'           | 'Store 02' | '36/Red'   | '5,000'    |
			| '14.09.2021 10:30:51' | 'Goods receipt 33 dated 14.09.2021 10:30:51' | '1'           | 'Store 02' | 'XS/Blue'  | '7,000'    |
			| '14.09.2021 10:31:48' | 'Goods receipt 34 dated 14.09.2021 10:31:48' | '1'           | 'Store 02' | 'XS/Blue'  | '43,000'   |
		
		
				
		
				
		
				
				



	
				
		
	
		

