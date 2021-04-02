#language: en
@tree
@Positive
@Sales

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
	When Create document PurchaseOrder objects (check reservation)
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(31).GetObject().Write(DocumentWriteMode.Posting);" |
	

Scenario: _0242001 create planned receipt reservation
	* Open planned receipt reservation
		Given I open hyperlink 'e1cib/list/Document.PlannedReceiptReservation'
		And I click the button named "FormCreate"
	* Filling in main info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Store (incoming)" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I click Select button of "Requester" field
		And I go to line in "List" table
			| 'Number' |
			| '31'     |
		And I select current line in "List" table
	* Filling in items tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' | 
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '36/Red'   |
		And I select current line in "List" table
		And I activate "Store (requester)" field in "ItemList" table
		And I click choice button of "Store (requester)" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Incoming document" field in "ItemList" table
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
				

				
		
	
		

