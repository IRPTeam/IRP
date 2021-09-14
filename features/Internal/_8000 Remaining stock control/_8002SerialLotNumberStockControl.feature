#language: en
@tree
@Positive
@StockControl


Feature: check serial lot number stock control

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario:_800020 preparation (remaining stock control)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog CancelReturnReasons objects
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
		When Create catalog Stores objects (with remaining stock control)
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
	* Stock remaining settings
		When Create CustomUserSettings objects (CheckSerialLotNumber balance)
		When Create information register UserSettings records (remaining stock control)

	* Load documents
		When Create information register UserSettings records (Retail document)
	When create payment terminal
	When create PaymentTypes
	When create bank terms
	* Workstation
		If "List" table does not contain lines Then
			| "Description" |
			| "Bank term 01" |
			When create Workstation
	When Create catalog SerialLotNumbers objects (for Phone)
	When Create Item with SerialLotNumbers (Phone)
	When Create document Purchase invoice objects (with SerialLotNumber)
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(1252).GetObject().Write(DocumentWriteMode.Posting);" |



Scenario:_800021 check serial lot number control in the Sales invoice 
		And I close all client application windows
		* Create SI 
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Ferron BP'   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'       |
				| 'Company Ferron BP' |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'              |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'    |
			And I select current line in "List" table
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			Then "Items" window is opened
			And I go to line in "List" table
				| 'Description' | 'Reference' |
				| 'Phone A'     | 'Phone A'   |
			And I activate field named "Description" in "List" table
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'    | 'Item key' |
				| 'Phone A' | 'Blue'     |
			And I activate field named "Item" in "List" table
			And I go to line in "List" table
				| 'Item'    | 'Item key' |
				| 'Phone A' | 'Brown'    |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I activate "Serial number" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "6,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "6,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I expand a line in "SerialLotNumbersTree" table
				| 'Item'    | 'Item key' | 'Item key quantity' | 'Quantity' |
				| 'Phone A' | 'Brown'    | '6,000'             | '6,000'    |
			And I finish line editing in "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "150,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then I wait that in user messages the "Line No. [1] [Phone A Brown] Serial lot number remaining: 5 . Required: 6 . Lacking: 1 ." substring will appear in 10 seconds
		* Change quantity and post SI
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I select current line in "ItemList" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I expand a line in "SerialLotNumbersTree" table
				| 'Item'    | 'Item key' | 'Item key quantity' | 'Quantity' |
				| 'Phone A' | 'Brown'    | '5,000'             | '6,000'    |
			And I finish line editing in "ItemList" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then user message window does not contain messages
		And I close all client application windows

Scenario:_800022 check remaining stock control in the Retail sales receipt					
		And I close all client application windows
		* Create Retail sales receipt
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Ferron BP'   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'       |
				| 'Company Ferron BP' |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'              |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'    |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Phone A'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Phone A' | 'Brown'  |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "7,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I activate "Serial number" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "7,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate "Price" field in "ItemList" table
			And I input "120,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I move to "Payments" tab
			And in the table "Payments" I click the button named "PaymentsAdd"
			And I click choice button of "Payment type" attribute in "Payments" table
			And I go to line in "List" table
				| 'Code' | 'Description' | 'Reference' |
				| '1'    | 'Cash'        | 'Cash'      |
			And I select current line in "List" table
			And I activate field named "PaymentsAmount" in "Payments" table
			And I input "840,00" text in the field named "PaymentsAmount" of "Payments" table
			And I finish line editing in "Payments" table
			And I move to "Item list" tab
			And I click "Post" button
		* Check serial lot numbers balance control
			Then I wait that in user messages the "Line No. [1] [Phone A Brown] Serial lot number remaining: 0 . Required: 7 . Lacking: 7 ." substring will appear in 10 seconds
		* Change serial lot number and post Retail sales receipt
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I select current line in "SerialLotNumbers" table
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'Brown' | '13456778'      |
			And I select current line in "List" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then user message window does not contain messages
		And I close all client application windows


			
						

			
			
						
			
						
		
			
						
			
	