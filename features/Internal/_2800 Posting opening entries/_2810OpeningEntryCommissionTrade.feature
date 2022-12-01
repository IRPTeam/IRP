#language: en
@tree
@Positive
@OpeningEntries

Feature: opening entry for commission trade


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



# it's necessary to add tests to start the remainder of the documents
Scenario: _410010 preparation (Opening entries)
	When set True value to the constant
	When set True value to the constant Use commission trading
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
		When Create catalog Stores (trade agent)
		When Create catalog Stores objects
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
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create information register Barcodes records
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog Partners objects (trade agent and consignor)
		When Create catalog Agreements objects (commision trade, own companies)
		When Create information register TaxSettings records (Concignor 1)
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
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
		When add sales tax settings 
	* Company settings
		Given I open hyperlink "e1cib/list/Catalog.Companies"	
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I move to "Comission trading" tab
		And I click Select button of "Trade agent store" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Trade agent store' |
		And I select current line in "List" table
		And I click "Save and close" button
		And I close all client application windows				
	
Scenario: _410011 check preparation
	When check preparation

Scenario: _410012 create Opening entry shipment to trade agent
	And I close all client application windows
	* Create OP (inventory balance for items that shipped to trade agent)
		* Open document form opening entry
			Given I open hyperlink "e1cib/list/Document.OpeningEntry"
			And I click the button named "FormCreate"
		* Filling in company info
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in the tabular part Inventory
			* First item (without serial lot number)
				And I move to "Inventory" tab
				And in the table "Inventory" I click the button named "InventoryAdd"
				And I click choice button of "Item" attribute in "Inventory" table
				And I go to line in "List" table
					| 'Description' |
					| 'Dress'       |
				And I select current line in "List" table
				And I click choice button of "Item key" attribute in "Inventory" table
				And I go to line in "List" table
					| Item  | Item key |
					| Dress | XS/Blue  |
				And I select current line in "List" table
				And I click choice button of "Store" attribute in "Inventory" table
				And I go to line in "List" table
					| Description |
					| Store 05    |
				And I select current line in "List" table
				And I activate "Quantity" field in "Inventory" table
				And I input "100,000" text in "Quantity" field of "Inventory" table
				And I input "200,00" text in "Price" field of "Inventory" table
				And I input "3050,85" text in "Amount tax" field of "Inventory" table
				And I finish line editing in "Inventory" table
			* Second item (with serial lot number)
				And I move to "Inventory" tab
				And in the table "Inventory" I click the button named "InventoryAdd"
				And I click choice button of "Item" attribute in "Inventory" table
				And I go to line in "List" table
					| 'Description'        |
					| 'Product 1 with SLN' |
				And I select current line in "List" table
				And I click choice button of "Item key" attribute in "Inventory" table
				And I go to line in "List" table
					| 'Item'               | 'Item key' |
					| 'Product 1 with SLN' | 'PZU'      |
				And I select current line in "List" table
				And I click choice button of "Store" attribute in "Inventory" table
				And I go to line in "List" table
					| 'Description'       |
					| 'Store 05' |
				And I select current line in "List" table
				And I activate "Quantity" field in "Inventory" table
				And I input "100,000" text in "Quantity" field of "Inventory" table
				And I input "200,00" text in "Price" field of "Inventory" table
				And I input "3050,85" text in "Amount tax" field of "Inventory" table
				And I finish line editing in "Inventory" table
				And I activate field named "InventorySerialLotNumber" in "Inventory" table
				And I select current line in "Inventory" table
				And I click choice button of the attribute named "InventorySerialLotNumber" in "Inventory" table
				And I activate field named "Owner" in "List" table
				And I go to line in "List" table
					| 'Owner' | 'Reference'  | 'Serial number' |
					| 'PZU'   | '8908899879' | '8908899879'    |
				And I select current line in "List" table
				And I finish line editing in "Inventory" table
			* Third item (with serial lot number)
				And I move to "Inventory" tab
				And in the table "Inventory" I click the button named "InventoryAdd"
				And I click choice button of "Item" attribute in "Inventory" table
				And I go to line in "List" table
					| 'Description'        |
					| 'Product 3 with SLN' |
				And I select current line in "List" table
				And I click choice button of "Item key" attribute in "Inventory" table
				And I go to line in "List" table
					| 'Item'               | 'Item key'  |
					| 'Product 3 with SLN' | 'UNIQ'      |
				And I select current line in "List" table
				And I click choice button of "Store" attribute in "Inventory" table
				And I go to line in "List" table
					| 'Description'       |
					| 'Store 05' |
				And I select current line in "List" table
				And I activate "Quantity" field in "Inventory" table
				And I input "100,000" text in "Quantity" field of "Inventory" table
				And I input "200,00" text in "Price" field of "Inventory" table
				And I input "3050,85" text in "Amount tax" field of "Inventory" table
				And I finish line editing in "Inventory" table
				And I activate field named "InventorySerialLotNumber" in "Inventory" table
				And I select current line in "Inventory" table
				And I click choice button of the attribute named "InventorySerialLotNumber" in "Inventory" table
				And I activate field named "Owner" in "List" table
				And I go to line in "List" table
					| 'Owner' | 'Reference'      | 'Serial number'  |
					| 'UNIQ'  | '09987897977889' | '09987897977889' |
				And I select current line in "List" table
				And I finish line editing in "Inventory" table
		* Post document
			And I click the button named "FormPost"
			And I delete "$$NumberOpeningEntry410010$$" variable
			And I delete "$$OpeningEntry410010$$" variable
			And I save the value of "Number" field as "$$NumberOpeningEntry410010$$"
			And I save the window as "$$OpeningEntry410010$$"
			And I click the button named "FormPostAndClose"
			And Delay 5
		* Check creation
			And "List" table contains lines
				| 'Number' |
				|  '$$NumberOpeningEntry410010$$'    |
	* Create OP (shipment to trade agent 1)
			And I close all client application windows
		* Open document form opening entry
			Given I open hyperlink "e1cib/list/Document.OpeningEntry"
			And I click the button named "FormCreate"
		* Filling in company info
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I move to "Shipment to trade agent" tab
		* Filling in trade agent info 
			And I move to "Shipment to trade agent" tab			
			And I click Select button of "Trade agent" field
			And I go to line in "List" table
				| 'Description'   |
				| 'Trade agent 2' |
			And I select current line in "List" table
			Then the form attribute named "LegalNameTradeAgent" became equal to "Trade agent 2"
			Then the form attribute named "AgreementTradeAgent" became equal to "Trade agent 2"
		* First item (without serial lot number)
			And I move to "Shipment to trade agent" tab
			And in the table "ShipmentToTradeAgent" I click the button named "ShipmentToTradeAgentAdd"		
			And I click choice button of "Item" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| Item  | Item key |
				| Dress | XS/Blue  |
			And I select current line in "List" table
			And I click choice button of "Store" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| Description |
				| Store 05    |
			And I select current line in "List" table
			And I activate "Quantity" field in "ShipmentToTradeAgent" table
			And I input "50,000" text in "Quantity" field of "ShipmentToTradeAgent" table
			And I finish line editing in "ShipmentToTradeAgent" table						
		* Second item (with serial lot number)
			And in the table "ShipmentToTradeAgent" I click the button named "ShipmentToTradeAgentAdd"
			And I click choice button of "Item" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 1 with SLN' |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| 'Item'               | 'Item key' |
				| 'Product 1 with SLN' | 'PZU'      |
			And I select current line in "List" table
			And I click choice button of "Store" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Store 05' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ShipmentToTradeAgent" table
			And I input "70,000" text in "Quantity" field of "ShipmentToTradeAgent" table
			And I finish line editing in "ShipmentToTradeAgent" table
			And I activate field named "ShipmentToTradeAgentSerialLotNumber" in "ShipmentToTradeAgent" table
			And I select current line in "ShipmentToTradeAgent" table
			And I click choice button of the attribute named "ShipmentToTradeAgentSerialLotNumber" in "ShipmentToTradeAgent" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Reference'  | 'Serial number' |
				| 'PZU'   | '8908899879' | '8908899879'    |
			And I select current line in "List" table
			And I finish line editing in "ShipmentToTradeAgent" table	
		* Post document
			And I click the button named "FormPost"
			And I delete "$$NumberOpeningEntry4100101$$" variable
			And I delete "$$OpeningEntry4100101$$" variable
			And I save the value of "Number" field as "$$NumberOpeningEntry4100101$$"
			And I save the window as "$$OpeningEntry4100101$$"
			And I click the button named "FormPostAndClose"
			And Delay 5
		* Check creation
			And "List" table contains lines
				| 'Number' |
				|  '$$NumberOpeningEntry4100101$$'    |	
	* Create OP (shipment to trade agent 2)
			And I close all client application windows
		* Open document form opening entry
			Given I open hyperlink "e1cib/list/Document.OpeningEntry"
			And I click the button named "FormCreate"
		* Filling in company info
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I move to "Shipment to trade agent" tab
		* Filling in trade agent info 
			And I click Select button of "Trade agent" field
			And I go to line in "List" table
				| 'Description'   |
				| 'Trade agent 1' |
			And I select current line in "List" table
			Then the form attribute named "LegalNameTradeAgent" became equal to "Trade agent 1"
			Then the form attribute named "AgreementTradeAgent" became equal to "Trade agent partner term 1"
		* First item (without serial lot number)
			And I move to "Shipment to trade agent" tab
			And in the table "ShipmentToTradeAgent" I click the button named "ShipmentToTradeAgentAdd"
			And I click choice button of "Item" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| Item  | Item key |
				| Dress | XS/Blue  |
			And I select current line in "List" table
			And I click choice button of "Store" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| Description |
				| Store 05    |
			And I select current line in "List" table
			And I activate "Quantity" field in "ShipmentToTradeAgent" table
			And I input "30,000" text in "Quantity" field of "ShipmentToTradeAgent" table
			And I finish line editing in "ShipmentToTradeAgent" table						
		* Second item (with serial lot number)
			And I move to "Shipment to trade agent" tab
			And in the table "ShipmentToTradeAgent" I click the button named "ShipmentToTradeAgentAdd"
			And I click choice button of "Item" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 1 with SLN' |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| 'Item'               | 'Item key' |
				| 'Product 1 with SLN' | 'PZU'      |
			And I select current line in "List" table
			And I click choice button of "Store" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Store 05' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ShipmentToTradeAgent" table
			And I input "20,000" text in "Quantity" field of "ShipmentToTradeAgent" table
			And I finish line editing in "ShipmentToTradeAgent" table
			And I activate field named "ShipmentToTradeAgentSerialLotNumber" in "ShipmentToTradeAgent" table
			And I select current line in "ShipmentToTradeAgent" table
			And I click choice button of the attribute named "ShipmentToTradeAgentSerialLotNumber" in "ShipmentToTradeAgent" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Reference'  | 'Serial number' |
				| 'PZU'   | '8908899879' | '8908899879'    |
			And I select current line in "List" table
			And I finish line editing in "ShipmentToTradeAgent" table
		* Third item (with serial lot number)
			And I move to "Shipment to trade agent" tab
			And in the table "ShipmentToTradeAgent" I click the button named "ShipmentToTradeAgentAdd"
			And I click choice button of "Item" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 3 with SLN' |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| 'Item'               | 'Item key'  |
				| 'Product 3 with SLN' | 'UNIQ'      |
			And I select current line in "List" table
			And I click choice button of "Store" attribute in "ShipmentToTradeAgent" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Store 05' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ShipmentToTradeAgent" table
			And I input "100,000" text in "Quantity" field of "ShipmentToTradeAgent" table
			And I finish line editing in "ShipmentToTradeAgent" table
			And I activate field named "ShipmentToTradeAgentSerialLotNumber" in "ShipmentToTradeAgent" table
			And I select current line in "ShipmentToTradeAgent" table
			And I click choice button of the attribute named "ShipmentToTradeAgentSerialLotNumber" in "ShipmentToTradeAgent" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Reference'      | 'Serial number'  |
				| 'UNIQ'  | '09987897977889' | '09987897977889' |
			And I select current line in "List" table
			And I finish line editing in "ShipmentToTradeAgent" table	
		* Post document
			And I click the button named "FormPost"
			And I delete "$$NumberOpeningEntry41001012$$" variable
			And I delete "$$OpeningEntry41001012$$" variable
			And I save the value of "Number" field as "$$NumberOpeningEntry41001012$$"
			And I save the window as "$$OpeningEntry41001012$$"
			And I click the button named "FormPostAndClose"
			And Delay 5
		* Check creation
			And I go to line in "List" table
				| 'Number' |
				|  '$$NumberOpeningEntry41001012$$'    |
			And I select current line in "List" table
			And "ShipmentToTradeAgent" table became equal
				| '#' | 'Item'               | 'Item key' | 'Store'    | 'Quantity' | 'Item serial/lot number' |
				| '1' | 'Dress'              | 'XS/Blue'  | 'Store 05' | '30,000'   | ''                       |
				| '2' | 'Product 1 with SLN' | 'PZU'      | 'Store 05' | '20,000'   | '8908899879'             |
				| '3' | 'Product 3 with SLN' | 'UNIQ'     | 'Store 05' | '100,000'  | '09987897977889'         |
			Then the form attribute named "LegalNameTradeAgent" became equal to "Trade agent 1"
			Then the form attribute named "AgreementTradeAgent" became equal to "Trade agent partner term 1"			
		
								
	
Scenario: _410013 create Opening entry receipt from consignor	
			And I close all client application windows
		* Open document form opening entry
			Given I open hyperlink "e1cib/list/Document.OpeningEntry"
			And I click the button named "FormCreate"
		* Filling in company info
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in trade agent info 
			And I move to "Receipt from consignor" tab			
			And I click Select button of "Consignor" field
			And I go to line in "List" table
				| 'Description'   |
				| 'Consignor 1'   |
			And I select current line in "List" table
			Then the form attribute named "LegalNameConsignor" became equal to "Consignor 1"
			Then the form attribute named "AgreementConsignor" became equal to "Consignor partner term 1"
		* First item (without serial lot number)
			And I move to "Receipt from consignor" tab
			And in the table "ReceiptFromConsignor" I click the button named "ReceiptFromConsignorAdd"
			And I click choice button of "Item" attribute in "ReceiptFromConsignor" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ReceiptFromConsignor" table
			And I go to line in "List" table
				| Item  | Item key |
				| Dress | M/White  |
			And I select current line in "List" table
			And I click choice button of "Store" attribute in "ReceiptFromConsignor" table
			And I go to line in "List" table
				| Description |
				| Store 08    |
			And I select current line in "List" table
			And I activate "Quantity" field in "ReceiptFromConsignor" table
			And I input "50,000" text in "Quantity" field of "ReceiptFromConsignor" table
			And I click choice button of the attribute named "ReceiptFromConsignorCurrency" in "ReceiptFromConsignor" table
			And I go to line in "List" table
				| 'Code' | 'Description'  | 'Reference' |
				| 'TRY'  | 'Turkish lira' | 'TRY'       |
			And I select current line in "List" table
			And I activate "Price" field in "ReceiptFromConsignor" table
			And I input "50,00" text in "Quantity" field of "ReceiptFromConsignor" table	
			And I input "50,000" text in "Price" field of "ReceiptFromConsignor" table
			And I input "381,36" text in "Amount tax" field of "ReceiptFromConsignor" table			
			And I finish line editing in "ReceiptFromConsignor" table						
		* Second item (with serial lot number)
			And in the table "ReceiptFromConsignor" I click the button named "ReceiptFromConsignorAdd"
			And I click choice button of "Item" attribute in "ReceiptFromConsignor" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 1 with SLN' |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ReceiptFromConsignor" table
			And I go to line in "List" table
				| 'Item'               | 'Item key' |
				| 'Product 1 with SLN' | 'PZU'      |
			And I select current line in "List" table
			And I click choice button of "Store" attribute in "ReceiptFromConsignor" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Store 08' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ReceiptFromConsignor" table
			And I input "70,000" text in "Quantity" field of "ReceiptFromConsignor" table
			And I input "50,000" text in "Price" field of "ReceiptFromConsignor" table	
			And I finish line editing in "ReceiptFromConsignor" table
			And I activate field named "ReceiptFromConsignorSerialLotNumber" in "ReceiptFromConsignor" table
			And I select current line in "ReceiptFromConsignor" table
			And I click choice button of the attribute named "ReceiptFromConsignorSerialLotNumber" in "ReceiptFromConsignor" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Reference'  | 'Serial number' |
				| 'PZU'   | '8908899877' | '8908899877'    |
			And I select current line in "List" table
			And I click choice button of the attribute named "ReceiptFromConsignorCurrency" in "ReceiptFromConsignor" table
			And I go to line in "List" table
				| 'Code' | 'Description'  | 'Reference' |
				| 'TRY'  | 'Turkish lira' | 'TRY'       |
			And I select current line in "List" table
			And I activate "Price" field in "ReceiptFromConsignor" table
			And I input "50,000" text in "Price" field of "ReceiptFromConsignor" table	
			And I input "533,90" text in "Amount tax" field of "ReceiptFromConsignor" table		
			And I finish line editing in "ReceiptFromConsignor" table	
		* Post document
			And I click the button named "FormPost"
			And "ReceiptFromConsignor" table became equal
				| '#' | 'Amount'   | 'Item'               | 'Item key' | 'Store'    | 'Quantity' | 'Currency' | 'Price' | 'Amount tax' | 'Item serial/lot number' |
				| '1' | '2 500,00' | 'Dress'              | 'M/White'  | 'Store 08' | '50,000'   | 'TRY'      | '50,00' | '381,36'     | ''                       |
				| '2' | '3 500,00' | 'Product 1 with SLN' | 'PZU'      | 'Store 08' | '70,000'   | 'TRY'      | '50,00' | '533,90'     | '8908899877'             |			
			And I delete "$$NumberOpeningEntry4100101$$" variable
			And I delete "$$OpeningEntry4100101$$" variable
			And I save the value of "Number" field as "$$NumberOpeningEntry4100101$$"
			And I save the window as "$$OpeningEntry4100101$$"
			And I click the button named "FormPostAndClose"
			And Delay 5
		* Check creation
			And I go to line in "List" table
				| 'Number' |
				|  '$$NumberOpeningEntry4100101$$'    |	
			And I select current line in "List" table
			And "ReceiptFromConsignor" table became equal
				| '#' | 'Amount'   | 'Item'               | 'Item key' | 'Store'    | 'Quantity' | 'Currency' | 'Price' | 'Amount tax' | 'Item serial/lot number' |
				| '1' | '2 500,00' | 'Dress'              | 'M/White'  | 'Store 08' | '50,000'   | 'TRY'      | '50,00' | '381,36'     | ''                       |
				| '2' | '3 500,00' | 'Product 1 with SLN' | 'PZU'      | 'Store 08' | '70,000'   | 'TRY'      | '50,00' | '533,90'     | '8908899877'             |	
			Then the form attribute named "LegalNameConsignor" became equal to "Consignor 1"
			Then the form attribute named "AgreementConsignor" became equal to "Consignor partner term 1"		