#language: en
@tree
@Positive
@Sales

Functionality: Goods receipt - Sales return

Scenario: _028400 preparation (GR-SR)
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
	When Create document SalesInvoice objects



Scenario: _028401 create GR with transaction type return from customer and create Sales return
	* Open form Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
		And I select "Return from customer" exact value from "Transaction type" drop-down list
	* Filling in main info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'|
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'     |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Filling in items info
		And I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$GoodsReceipt028401$$" variable
        And I delete "$$NumberGoodsReceipt028401$$" variable
        And I save the window as "$$GoodsReceipt028401$$"
        And I save the value of "Number" field as "$$NumberGoodsReceipt028401$$"
        And I close current window
	* Create SR
		And I click "Sales return" button
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Q'     | 'Unit' |
			| 'Trousers' | '38/Yellow' | '1,000' | 'pcs'  |
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                      |
			| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		* Select SI
			And I select current line in "ItemList" table
			And I click choice button of "Sales invoice" attribute in "ItemList" table
			And I go to line in "" table
				| ''              |
				| 'Sales invoice' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Amount' | 'Company'      | 'Currency' | 'Date'                | 'Legal name'      | 'Partner' |
				| '800,00' | 'Main Company' | 'TRY'      | '07.10.2020 01:19:02' | 'Company Kalipso' | 'Kalipso' |
			And I select current line in "List" table			
		And I click "Post" button
		And I delete "$$SalesReturn028401$$" variable
		And I delete "$$NumberSalesReturn028401$$" variable
		And I save the window as "$$SalesReturn028401$$"
		And I save the value of "Number" field as "$$NumberSalesReturn028401$$"
		And I close current window
		
				


		
					
				
		
				


	


