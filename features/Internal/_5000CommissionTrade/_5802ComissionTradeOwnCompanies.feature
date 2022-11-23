﻿#language: en
@tree
@Positive
@CommissionTrade


Feature: commission own companies 



Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _05802 preparation (commission own companies, different tax systems)
	When set True value to the constant
	When set True value to the constant Use commission trading
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create information register Barcodes records
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create catalog PaymentTypes objects
		When Create catalog CashAccounts objects
		When Create catalog CashAccounts objects (Second Company)
		When Create catalog Partners objects (trade agent and consignor)
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Companies objects (own Second company)
		When Create catalog Stores objects
		When Create catalog Stores (trade agent)
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create catalog Agreements objects (commision trade, own companies)
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create catalog Taxes objects (for commission trade)
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog UserGroups objects
		When Create catalog PaymentTypes objects
		When Create catalog BankTerms objects (for Shop 02)	
		When Create information register UserSettings records (Retail)
		When Create catalog BusinessUnits objects (Shop 02, use consolidated retail sales)	
		When Create catalog Workstations objects
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'    |
			| 'Workstation 01' |
		And I click "Set current workstation" button		
		When Create information register TaxSettings records (Concignor 1)
		When update ItemKeys
		When Create catalog Partners objects
		When Data preparation (comission stock)
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"        |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)
	* Tax settings
		When filling in Tax settings for company
	* Setting for Company
		When settings for Company (commission trade)
	* Load PI
		When Create document PurchaseInvoice (comission trade, own Companies)
		When Create document SalesInvoice (trade, own Companies)
	* Post document
		And I execute 1C:Enterprise script at server
 			| "Documents.PurchaseInvoice.FindByNumber(2200).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
 			| "Documents.PurchaseInvoice.FindByNumber(192).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
 			| "Documents.PurchaseInvoice.FindByNumber(2201).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
 			| "Documents.PurchaseInvoice.FindByNumber(2202).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
 			| "Documents.PurchaseInvoice.FindByNumber(2203).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
 			| "Documents.PurchaseInvoice.FindByNumber(2206).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
 			| "Documents.PurchaseInvoice.FindByNumber(2209).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesInvoice.FindByNumber(2200).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesInvoice.FindByNumber(2201).GetObject().Write(DocumentWriteMode.Posting);" |
		
	And I close all client application windows

Scenario: _05803 check preparation
	When check preparation

Scenario: _05805 transfer of goods on commission from Second company to the Main company (SI and PI)
	And I close all client application windows
	* Open SI form
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I select "Shipment to trade agent" exact value from "Transaction type" drop-down list
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company partner' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Second Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 04' |
		And I select current line in "List" table
	* Add items
		* Product 1 with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 1 with SLN' |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'               | 'Item key' |
				| 'Product 1 with SLN' | 'PZU'      |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'PZU'   | '8908899880'    |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I input "500,000" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Product 3 with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 3 with SLN' |
			And I select current line in "List" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'               | 'Item key' |
				| 'Product 3 with SLN' | 'UNIQ'     |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number'  |
				| 'UNIQ'  | '09987897977891' |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I input "520,000" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add Scarf
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Scarf'       |
			And I select current line in "List" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "100,000" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add Dress
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/Brown'  |
			And I select current line in "List" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "200,000" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
	* Check filling
		And "ItemList" table contains lines
			| 'Inventory origin' | 'Price type'              | 'Item'               | 'Item key' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT'         | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Is additional item revenue' | 'Store'    |
			| 'Own stocks'       | 'en description is empty' | 'Product 1 with SLN' | 'PZU'      | 'No'                 | ''           | 'pcs'  | '8908899880'         | '1,000'    | '500,00' | 'Without VAT' | '500,00'     | '500,00'       | 'No'             | 'No'                         | 'Store 04' |
			| 'Own stocks'       | 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | 'No'                 | ''           | 'pcs'  | '09987897977891'     | '5,000'    | '520,00' | 'Without VAT' | '2 600,00'   | '2 600,00'     | 'No'             | 'No'                         | 'Store 04' |
			| 'Own stocks'       | 'en description is empty' | 'Scarf'              | 'XS/Red'   | 'No'                 | ''           | 'pcs'  | ''                   | '5,000'    | '100,00' | 'Without VAT' | '500,00'     | '500,00'       | 'No'             | 'No'                         | 'Store 04' |
			| 'Own stocks'       | 'en description is empty' | 'Dress'              | 'M/Brown'  | 'No'                 | ''           | 'pcs'  | ''                   | '5,000'    | '200,00' | 'Without VAT' | '1 000,00'   | '1 000,00'     | 'No'             | 'No'                         | 'Store 04' |
	* Post
		And I click "Post" button
		And I delete "$$NumberSI5$$" variable
		And I delete "$$SI5$$" variable
		And I delete "$$DateSI5$$" variable
		And I save the value of "Number" field as "$$NumberSI5$$"
		And I save the window as "$$SI5$$"
		And I save the value of the field named "Date" as "$$DateSI5$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberSI5$$' |
		And I close all client application windows
	* Open PI form
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I select "Receipt from consignor" exact value from "Transaction type" drop-down list
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Second Company partner' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01' |
		And I select current line in "List" table
	* Add items
		* Product 1 with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 1 with SLN' |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'               | 'Item key' |
				| 'Product 1 with SLN' | 'PZU'      |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'PZU'   | '8908899880'    |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I input "500,000" text in the field named "ItemListPrice" of "ItemList" table
			And I select "Without VAT" exact value from "VAT" drop-down list in "ItemList" table	
			And I finish line editing in "ItemList" table
		* Product 3 with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 3 with SLN' |
			And I select current line in "List" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'               | 'Item key' |
				| 'Product 3 with SLN' | 'UNIQ'     |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number'  |
				| 'UNIQ'  | '09987897977891' |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I input "520,000" text in the field named "ItemListPrice" of "ItemList" table
			And I select "Without VAT" exact value from "VAT" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
		* Add Scarf
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Scarf'       |
			And I select current line in "List" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "100,000" text in the field named "ItemListPrice" of "ItemList" table
			And I select "Without VAT" exact value from "VAT" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
		* Add Dress
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/Brown'  |
			And I select current line in "List" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "200,000" text in the field named "ItemListPrice" of "ItemList" table
			And I select "Without VAT" exact value from "VAT" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
	* Check filling
		And "ItemList" table became equal
			| 'Price type'              | 'Item'               | 'Item key' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Price'  | 'VAT'         | 'Total amount' | 'Store'    | 'Delivery date' | 'Quantity' | 'Is additional item cost' | 'Net amount' |
			| 'en description is empty' | 'Product 1 with SLN' | 'PZU'      | 'No'                 | ''           | 'pcs'  | '8908899880'         | '500,00' | 'Without VAT' | '500,00'       | 'Store 01' | ''              | '1,000'    | 'No'                      | '500,00'     |
			| 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | 'No'                 | ''           | 'pcs'  | '09987897977891'     | '520,00' | 'Without VAT' | '2 600,00'     | 'Store 01' | ''              | '5,000'    | 'No'                      | '2 600,00'   |
			| 'en description is empty' | 'Scarf'              | 'XS/Red'   | 'No'                 | ''           | 'pcs'  | ''                   | '100,00' | 'Without VAT' | '500,00'       | 'Store 01' | ''              | '5,000'    | 'No'                      | '500,00'     |
			| 'en description is empty' | 'Dress'              | 'M/Brown'  | 'No'                 | ''           | 'pcs'  | ''                   | '200,00' | 'Without VAT' | '1 000,00'     | 'Store 01' | ''              | '5,000'    | 'No'                      | '1 000,00'   |
	* Post
		And I click "Post" button
		And I delete "$$NumberPI5$$" variable
		And I delete "$$PI5$$" variable
		And I delete "$$DatePI5$$" variable
		And I save the value of "Number" field as "$$NumberPI5$$"
		And I save the window as "$$PI5$$"
		And I save the value of the field named "Date" as "$$DatePI5$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberPI5$$' |
		And I close all client application windows
	* Open SI form
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I select "Shipment to trade agent" exact value from "Transaction type" drop-down list
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company partner' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Second Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 04' |
		And I select current line in "List" table
	* Add items
		* Product 1 with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 1 with SLN' |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'               | 'Item key' |
				| 'Product 1 with SLN' | 'PZU'      |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'PZU'   | '8908899881'    |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I input "500,000" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Product 3 with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 3 with SLN' |
			And I select current line in "List" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'               | 'Item key' |
				| 'Product 3 with SLN' | 'UNIQ'     |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number'  |
				| 'UNIQ'  | '09987897977891' |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I input "520,000" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add Scarf
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Scarf'       |
			And I select current line in "List" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "100,000" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add Dress
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/Brown'  |
			And I select current line in "List" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "200,000" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
	* Post
		And I click "Post" button
		And I delete "$$NumberSI6$$" variable
		And I delete "$$SI6$$" variable
		And I delete "$$DateSI6$$" variable
		And I save the value of "Number" field as "$$NumberSI6$$"
		And I save the window as "$$SI6$$"
		And I save the value of the field named "Date" as "$$DateSI6$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberSI6$$' |
		And I close all client application windows
	* Open PI form
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I select "Receipt from consignor" exact value from "Transaction type" drop-down list
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Second Company partner' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01' |
		And I select current line in "List" table
	* Add items
		* Product 1 with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 1 with SLN' |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'               | 'Item key' |
				| 'Product 1 with SLN' | 'PZU'      |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'PZU'   | '8908899881'    |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I input "500,000" text in the field named "ItemListPrice" of "ItemList" table
			And I select "Without VAT" exact value from "VAT" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
		* Product 3 with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 3 with SLN' |
			And I select current line in "List" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'               | 'Item key' |
				| 'Product 3 with SLN' | 'UNIQ'     |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number'  |
				| 'UNIQ'  | '09987897977891' |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I input "520,000" text in the field named "ItemListPrice" of "ItemList" table
			And I select "Without VAT" exact value from "VAT" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
		* Add Scarf
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Scarf'       |
			And I select current line in "List" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "100,000" text in the field named "ItemListPrice" of "ItemList" table
			And I select "Without VAT" exact value from "VAT" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
		* Add Dress
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/Brown'  |
			And I select current line in "List" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "200,000" text in the field named "ItemListPrice" of "ItemList" table
			And I select "Without VAT" exact value from "VAT" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
	* Post
		And I click "Post" button
		And I delete "$$NumberPI6$$" variable
		And I delete "$$PI6$$" variable
		And I delete "$$DatePI6$$" variable
		And I save the value of "Number" field as "$$NumberPI6$$"
		And I save the window as "$$PI6$$"
		And I save the value of the field named "Date" as "$$DatePI6$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberPI6$$' |
		And I close all client application windows

Scenario: _05806 sale of commission goods from the Main Company (Sales invoice)
	And I close all client application windows
	* Create first SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso' |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01' |
		And I select current line in "List" table
	* Check tax rate
		* Item with unique serial lot number
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "8908899881" text in the field named "InputFld"
			And I click the button named "OK"
			And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table
			And I input "200,000" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Inventory origin' | 'Item'               | 'Item key' | 'Serial lot numbers' | 'VAT'         |
				| 'Consignor stocks' | 'Product 1 with SLN' | 'PZU'      | '8908899881'         | 'Without VAT' |	
		* Item without unique serial lot number
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "09987897977891" text in the field named "InputFld"
			And I click the button named "OK"
			And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table	
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			Then "Select serial lot numbers" window is opened
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "6,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I input "200,000" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Inventory origin' | 'Item'               | 'Item key' | 'Serial lot numbers' | 'VAT'         | 'Quantity'     |
				| 'Consignor stocks' | 'Product 3 with SLN' | 'UNIQ'     | '09987897977891'     | 'Without VAT' | '6,000'        |
		* Item without serial lot number (different tax rate)
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/Brown'  |
			And I select current line in "List" table
			And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table	
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/Brown'  |
			And I select current line in "List" table
			And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table	
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check
			And "ItemList" table became equal
				| 'Inventory origin' | 'Price type'              | 'Item'               | 'Item key' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Consignor stocks' | 'en description is empty' | 'Product 1 with SLN' | 'PZU'      | ''           | 'pcs'  | '8908899881'         | '1,000'    | '200,00' | 'Without VAT' | ''              | '200,00'     | '200,00'       | 'Store 01' |
				| 'Consignor stocks' | 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | ''           | 'pcs'  | '09987897977891'     | '6,000'    | '200,00' | 'Without VAT' | ''              | '1 200,00'   | '1 200,00'     | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | '152,54'     | 'pcs'  | ''                   | '2,000'    | '500,00' | '18%'         | ''              | '847,46'     | '1 000,00'     | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | ''           | 'pcs'  | ''                   | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
		* Change inventory origin and check tax rate
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'VAT'         |
				| '4' | 'Dress' | 'M/Brown'  | 'Without VAT' |
			And I activate "Inventory origin" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "Own stocks" exact value from "Inventory origin" drop-down list in "ItemList" table
			And "ItemList" table became equal
				| 'Inventory origin' | 'Price type'              | 'Item'               | 'Item key' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Consignor stocks' | 'en description is empty' | 'Product 1 with SLN' | 'PZU'      | ''           | 'pcs'  | '8908899881'         | '1,000'    | '200,00' | 'Without VAT' | ''              | '200,00'     | '200,00'       | 'Store 01' |
				| 'Consignor stocks' | 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | ''           | 'pcs'  | '09987897977891'     | '6,000'    | '200,00' | 'Without VAT' | ''              | '1 200,00'   | '1 200,00'     | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | '152,54'     | 'pcs'  | ''                   | '2,000'    | '500,00' | '18%'         | ''              | '847,46'     | '1 000,00'     | 'Store 01' |
				| 'Own stocks'       | 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | '152,54'     | 'pcs'  | ''                   | '2,000'    | '500,00' | '18%'         | ''              | '847,46'     | '1 000,00'     | 'Store 01' |
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'VAT' |
				| '4' | 'Dress' | 'M/Brown'  | '18%' |
			And I activate "Inventory origin" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table			
			And "ItemList" table became equal
				| 'Inventory origin' | 'Price type'              | 'Item'               | 'Item key' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Consignor stocks' | 'en description is empty' | 'Product 1 with SLN' | 'PZU'      | ''           | 'pcs'  | '8908899881'         | '1,000'    | '200,00' | 'Without VAT' | ''              | '200,00'     | '200,00'       | 'Store 01' |
				| 'Consignor stocks' | 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | ''           | 'pcs'  | '09987897977891'     | '6,000'    | '200,00' | 'Without VAT' | ''              | '1 200,00'   | '1 200,00'     | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | '152,54'     | 'pcs'  | ''                   | '2,000'    | '500,00' | '18%'         | ''              | '847,46'     | '1 000,00'     | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | ''           | 'pcs'  | ''                   | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
	* Post
		And I click "Post" button
		And I delete "$$NumberSI7$$" variable
		And I delete "$$SI7$$" variable
		And I delete "$$DateSI7$$" variable
		And I save the value of "Number" field as "$$NumberSI7$$"
		And I save the window as "$$SI7$$"
		And I save the value of the field named "Date" as "$$DateSI7$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberSI7$$' |
		And I close all client application windows	
	* Create second SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso' |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01' |
		And I select current line in "List" table
	* Add items
		* First item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/Brown'  |
			And I select current line in "List" table
			And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table	
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Second item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
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
			And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table	
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "100,000" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
	* Check tax rate
		And "ItemList" table contains lines
			| '#' | 'Inventory origin' | 'Price type'              | 'Item'  | 'Item key' | 'Tax amount' | 'Unit' | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '1' | 'Consignor stocks' | 'Basic Price Types'       | 'Dress' | 'M/Brown'  | ''           | 'pcs'  | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
			| '2' | 'Consignor stocks' | 'en description is empty' | 'Scarf' | 'XS/Red'   | '15,25'      | 'pcs'  | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | 'Store 01' |
	* Post
		And I click "Post" button
		And I delete "$$NumberSI8$$" variable
		And I delete "$$SI8$$" variable
		And I delete "$$DateSI8$$" variable
		And I save the value of "Number" field as "$$NumberSI8$$"
		And I save the window as "$$SI8$$"
		And I save the value of the field named "Date" as "$$DateSI8$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberSI8$$' |
		And I close all client application windows			

Scenario: _05807 create sales report to consignor (Second Company partner) and sales report from trade agent
	And I close all client application windows
	* Open Sales report co consignor form
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"	
	* Create Sales report co consignor for Second Company partner
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Second Company partner' |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Second Company"
		Then the form attribute named "Agreement" became equal to "Consignor Second Company"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		Then the form attribute named "TradeAgentFeeType" became equal to "Percent"		
		And I input current date in "Start date" field
		And I input current date in "End date" field
	* Fill sales
		And in the table "ItemList" I click "Fill sales" button
		And in the table "Sales" I click "Fill sales" button
		And I click "Ok" button
		And "ItemList" table became equal
			| 'Price type'              | 'Item'               | 'Item key' | 'Consignor price' | 'Serial lot numbers' | 'Unit' | 'Sales invoice' | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'VAT'         | 'Purchase invoice' | 'Net amount' | 'Total amount' |
			| 'en description is empty' | 'Product 1 with SLN' | 'PZU'      | '500,00'          | '8908899881'         | 'pcs'  | '$$SI7$$'       | '1,000'    | '10,00'                   | '20,00'                  | '200,00' | 'Without VAT' | '$$PI6$$'          | '200,00'     | '200,00'       |
			| 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | '520,00'          | '09987897977891'     | 'pcs'  | '$$SI7$$'       | '5,000'    | '10,00'                   | '100,00'                 | '200,00' | 'Without VAT' | '$$PI5$$'          | '1 000,00'   | '1 000,00'     |
			| 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | '520,00'          | '09987897977891'     | 'pcs'  | '$$SI7$$'       | '1,000'    | '10,00'                   | '20,00'                  | '200,00' | 'Without VAT' | '$$PI6$$'          | '200,00'     | '200,00'       |
			| 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | '200,00'          | ''                   | 'pcs'  | '$$SI7$$'       | '2,000'    | '10,00'                   | '100,00'                 | '500,00' | 'Without VAT' | '$$PI5$$'          | '1 000,00'   | '1 000,00'     |
			| 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | '200,00'          | ''                   | 'pcs'  | '$$SI8$$'       | '2,000'    | '10,00'                   | '100,00'                 | '500,00' | 'Without VAT' | '$$PI5$$'          | '1 000,00'   | '1 000,00'     |
	* Post
		And I click "Post" button
		And I delete "$$NumberSRC3$$" variable
		And I delete "$$SRC3$$" variable
		And I delete "$$DateSRC3$$" variable
		And I save the value of "Number" field as "$$NumberSRC3$$"
		And I save the window as "$$SRC3$$"
		And I save the value of the field named "Date" as "$$DateSRC3$$"
		And I click "Post and close" button
	* Create Sales report from trade agent
		Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
		And I click "Create by sales report" button
		And I go to line in "SalesReportList" table
			| 'Number'         |
			| '$$NumberSRC3$$' |
		And I set "Use" checkbox in "SalesReportList" table
		And I finish line editing in "SalesReportList" table
		And I click "Ok" button
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'              |
			| 'Trade agent Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
	* Check
		Then the form attribute named "Partner" became equal to "Main Company partner"
		Then the form attribute named "LegalName" became equal to "Main Company"
		Then the form attribute named "Agreement" became equal to "Trade agent Main Company"
		Then the form attribute named "Company" became equal to "Second Company"
		Then the form attribute named "TradeAgentFeeType" became equal to "Percent"
		And "ItemList" table became equal
			| 'Price type'              | 'Item'               | 'Item key' | 'Consignor price' | 'Serial lot numbers' | 'Unit' | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'VAT'         | 'Net amount' | 'Total amount' |
			| 'en description is empty' | 'Product 1 with SLN' | 'PZU'      | '500,00'          | '8908899881'         | 'pcs'  | '1,000'    | '10,00'                   | '20,00'                  | '200,00' | 'Without VAT' | '200,00'     | '200,00'       |
			| 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | '520,00'          | '09987897977891'     | 'pcs'  | '5,000'    | '10,00'                   | '100,00'                 | '200,00' | 'Without VAT' | '1 000,00'   | '1 000,00'     |
			| 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | '520,00'          | '09987897977891'     | 'pcs'  | '1,000'    | '10,00'                   | '20,00'                  | '200,00' | 'Without VAT' | '200,00'     | '200,00'       |
			| 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | '200,00'          | ''                   | 'pcs'  | '2,000'    | '10,00'                   | '100,00'                 | '500,00' | 'Without VAT' | '1 000,00'   | '1 000,00'     |
			| 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | '200,00'          | ''                   | 'pcs'  | '2,000'    | '10,00'                   | '100,00'                 | '500,00' | 'Without VAT' | '1 000,00'   | '1 000,00'     |
		And "SerialLotNumbersTree" table became equal
			| 'Item'               | 'Item key' | 'Serial lot number' | 'Item key quantity' | 'Quantity' |
			| 'Product 1 with SLN' | 'PZU'      | ''                  | '1,000'             | '1,000'    |
			| ''                   | ''         | '8908899881'        | ''                  | '1,000'    |
			| 'Product 3 with SLN' | 'UNIQ'     | ''                  | '5,000'             | '5,000'    |
			| ''                   | ''         | '09987897977891'    | ''                  | '5,000'    |
			| 'Product 3 with SLN' | 'UNIQ'     | ''                  | '1,000'             | '1,000'    |
			| ''                   | ''         | '09987897977891'    | ''                  | '1,000'    |
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 400,00"
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "0,00"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 400,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post
		And I click "Post" button
		And I delete "$$NumberSRFromTradeAgent3$$" variable
		And I delete "$$SRFromTradeAgent3$$" variable
		And I delete "$$DateSRFromTradeAgent3$$" variable
		And I save the value of "Number" field as "$$NumberSRFromTradeAgent3$$"
		And I save the window as "$$SRFromTradeAgent3$$"
		And I save the value of the field named "Date" as "$$DateSRFromTradeAgent3$$"
		And I click "Post and close" button	
	* Check creation
		And "List" table contains lines
			| 'Number'                      |
			| '$$NumberSRFromTradeAgent3$$' |
		And I close all client application windows		
						
		
Scenario: _05818 create Bank payment based on Sales report to consignors
		And I close all client application windows
	* Select Sales report to consignor
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I go to line in "List" table
			| 'Number'         |
			| '$$NumberSRC3$$' |
	* Create Bank payment
		And I click the button named "FormDocumentBankPaymentGenarateBankPayment"
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Description'         |
			| 'Bank account, TRY'   |
		And I select current line in "List" table
	* Check
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Bank account, TRY"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#' | 'Partner'                | 'Commission' | 'Payee'          | 'Partner term'             | 'Legal name contract' | 'Basis document' | 'Order' | 'Total amount' | 'Financial movement type' | 'Planning transaction basis' |
			| '1' | 'Second Company partner' | ''           | 'Second Company' | 'Consignor Second Company' | ''                    | '$$SRC3$$'       | ''      | '3 400,00'     | ''                        | ''                           |
		And the editing text of form attribute named "DocumentAmount" became equal to "3 400,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Delete line and fill Bank payment manually
		And I delete all lines of "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"		
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Second Company partner' |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'              |
			| 'Consignor Second Company' |
		And I select current line in "List" table
		# temporarily
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		# temporarily
		And I go to line in "List" table
			| 'Document'            |
			| '$$SRC3$$' |
		And I select current line in "List" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "2 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| '#' | 'Partner'                | 'Commission' | 'Payee'          | 'Partner term'             | 'Legal name contract' | 'Basis document' | 'Order' | 'Total amount' | 'Financial movement type' | 'Planning transaction basis' |
			| '1' | 'Second Company partner' | ''           | 'Second Company' | 'Consignor Second Company' | ''                    | '$$SRC3$$'       | ''      | '2 000,00'     | ''                        | ''                           |
	* Post
		And I click "Post" button
		And I delete "$$NumberBP1$$" variable
		And I delete "$$BP1$$" variable
		And I delete "$$DateBP1$$" variable
		And I save the value of "Number" field as "$$NumberBP1$$"
		And I save the window as "$$BP1$$"
		And I save the value of the field named "Date" as "$$DateBP1$$"
		And I click "Post and close" button	
	* Check creation
		Given I open hyperlink "e1cib/list/Document.BankPayment"		
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberBP1$$' |
		And I close all client application windows	


Scenario: _05819 create Cash payment based on Sales report to consignors
		And I close all client application windows
	* Select Sales report to consignor
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I go to line in "List" table
			| 'Number'         |
			| '$$NumberSRC3$$' |
	* Create Bank payment
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"	
		And I click Choice button of the field named "CashAccount"
		And I go to line in "List" table
			| 'Description'    |
			| 'Cash desk №2'   |
		And I select current line in "List" table
	* Check
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №2"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#' | 'Partner'                | 'Payee'          | 'Partner term'             | 'Legal name contract' | 'Basis document' | 'Order' | 'Total amount' | 'Financial movement type' | 'Planning transaction basis' |
			| '1' | 'Second Company partner' | 'Second Company' | 'Consignor Second Company' | ''                    | '$$SRC3$$'       | ''      | '1 400,00'     | ''                        | ''                           |
		And the editing text of form attribute named "DocumentAmount" became equal to "1 400,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Delete line and fill Cash payment manually
		And I delete all lines of "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"		
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Second Company partner' |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'              |
			| 'Consignor Second Company' |
		And I select current line in "List" table
		# temporarily
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		# temporarily
		And I go to line in "List" table
			| 'Document'            |
			| '$$SRC3$$' |
		And I select current line in "List" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| '#' | 'Partner'                | 'Payee'          | 'Partner term'             | 'Legal name contract' | 'Basis document' | 'Order' | 'Total amount' | 'Financial movement type' | 'Planning transaction basis' |
			| '1' | 'Second Company partner' | 'Second Company' | 'Consignor Second Company' | ''                    | '$$SRC3$$'       | ''      | '1 000,00'     | ''                        | ''                           |
	* Post
		And I click "Post" button
		And I delete "$$NumberCP1$$" variable
		And I delete "$$CP1$$" variable
		And I delete "$$DateCP1$$" variable
		And I save the value of "Number" field as "$$NumberCP1$$"
		And I save the window as "$$CP1$$"
		And I save the value of the field named "Date" as "$$DateCP1$$"
		And I click "Post and close" button	
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashPayment"		
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberCP1$$' |
		And I close all client application windows				
		


Scenario: _05820 create Bank receipt based on Sales report from trade agent
		And I close all client application windows
	* Select Sales report from trade agent
		Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
		And I go to line in "List" table
			| 'Number'                      |
			| '$$NumberSRFromTradeAgent3$$' |
	* Create Bank payment
		And I click the button named "FormDocumentBankReceiptGenarateBankReceipt"
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Description'                        |
			| 'Bank account, TRY (Second Company)' |
		And I select current line in "List" table
	* Check
		Then the form attribute named "Company" became equal to "Second Company"
		Then the form attribute named "Account" became equal to "Bank account, TRY (Second Company)"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#' | 'Partner'              | 'Commission' | 'Payer'        | 'Partner term'             | 'Legal name contract' | 'Basis document'        | 'Order' | 'Total amount' | 'Financial movement type' | 'Planning transaction basis' |
			| '1' | 'Main Company partner' | ''           | 'Main Company' | 'Trade agent Main Company' | ''                    | '$$SRFromTradeAgent3$$' | ''      | '3 400,00'     | ''                        | ''                           |
		And the editing text of form attribute named "DocumentAmount" became equal to "3 400,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Delete line and fill Bank receipt manually
		And I delete all lines of "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"		
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Main Company partner'   |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'              |
			| 'Trade agent Main Company' |
		And I select current line in "List" table
		# temporarily
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		# temporarily
		And I go to line in "List" table
			| 'Document'                    |
			| '$$SRFromTradeAgent3$$' |
		And I select current line in "List" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "2 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| '#' | 'Partner'              | 'Commission' | 'Payer'        | 'Partner term'             | 'Legal name contract' | 'Basis document'        | 'Order' | 'Total amount' | 'Financial movement type' | 'Planning transaction basis' |
			| '1' | 'Main Company partner' | ''           | 'Main Company' | 'Trade agent Main Company' | ''                    | '$$SRFromTradeAgent3$$' | ''      | '2 000,00'     | ''                        | ''                           |
	* Post
		And I click "Post" button
		And I delete "$$NumberBR1$$" variable
		And I delete "$$BR1$$" variable
		And I delete "$$DateBR1$$" variable
		And I save the value of "Number" field as "$$NumberBR1$$"
		And I save the window as "$$BR1$$"
		And I save the value of the field named "Date" as "$$DateBR1$$"
		And I click "Post and close" button	
	* Check creation
		Given I open hyperlink "e1cib/list/Document.BankReceipt"		
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberBR1$$' |
		And I close all client application windows			



Scenario: _05821 create Cash receipt based on Sales report from trade agent
		And I close all client application windows
	* Select Sales report from trade agent
		Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
		And I go to line in "List" table
			| 'Number'                      |
			| '$$NumberSRFromTradeAgent3$$' |
	* Create Bank payment
		And I click the button named "FormDocumentCashReceiptGenarateCashReceipt"
		And I click Choice button of the field named "CashAccount"
		And I go to line in "List" table
			| 'Description'                   |
			| 'Cash desk №1 (Second Company)' |
		And I select current line in "List" table
	* Check
		Then the form attribute named "Company" became equal to "Second Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №1 (Second Company)"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#' | 'Partner'              | 'Payer'        | 'Partner term'             | 'Legal name contract' | 'Basis document'        | 'Order' | 'Total amount' | 'Financial movement type' | 'Planning transaction basis' |
			| '1' | 'Main Company partner' | 'Main Company' | 'Trade agent Main Company' | ''                    | '$$SRFromTradeAgent3$$' | ''      | '1 400,00'     | ''                        | ''                           |
		And the editing text of form attribute named "DocumentAmount" became equal to "1 400,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Delete line and fill Cash receipt manually
		And I delete all lines of "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"		
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Main Company partner'   |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'              |
			| 'Trade agent Main Company' |
		And I select current line in "List" table
		# temporarily
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		# temporarily
		And I go to line in "List" table
			| 'Document'                    |
			| '$$SRFromTradeAgent3$$' |
		And I select current line in "List" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| '#' | 'Partner'              | 'Payer'        | 'Partner term'             | 'Legal name contract' | 'Basis document'        | 'Order' | 'Total amount' | 'Financial movement type' | 'Planning transaction basis' |
			| '1' | 'Main Company partner' | 'Main Company' | 'Trade agent Main Company' | ''                    | '$$SRFromTradeAgent3$$' | ''      | '1 000,00'     | ''                        | ''                           |
	* Post
		And I click "Post" button
		And I delete "$$NumberBR1$$" variable
		And I delete "$$BR1$$" variable
		And I delete "$$DateBR1$$" variable
		And I save the value of "Number" field as "$$NumberBR1$$"
		And I save the window as "$$BR1$$"
		And I save the value of the field named "Date" as "$$DateBR1$$"
		And I click "Post and close" button	
	* Check creation
		Given I open hyperlink "e1cib/list/Document.BankReceipt"		
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberBR1$$' |
		And I close all client application windows			
				


Scenario: _05825 sale of commission goods from the Main Company (Retail sales receipt)
	And I close all client application windows
	* Create first RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Filling in the details
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'     |
			| 'Retail customer' |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description'         |
			| 'Retail partner term' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01' |
		And I select current line in "List" table
	* Check tax rate
		* Item with unique serial lot number
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "8908899880" text in the field named "InputFld"
			And I click the button named "OK"
			And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table
			And I input "200,000" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Inventory origin' | 'Item'               | 'Item key' | 'Serial lot numbers' | 'VAT'         |
				| 'Consignor stocks' | 'Product 1 with SLN' | 'PZU'      | '8908899880'         | 'Without VAT' |	
		* Item without serial lot number
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
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
			And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table	
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "100,000" text in the field named "ItemListPrice" of "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Scarf'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Scarf' | 'XS/Red'   |
			And I select current line in "List" table
			And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table	
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "100,000" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check
			And "ItemList" table became equal
				| 'Inventory origin' | 'Price type'              | 'Item'               | 'Item key' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Consignor stocks' | 'en description is empty' | 'Product 1 with SLN' | 'PZU'      | ''           | 'pcs'  | '8908899880'         | '1,000'    | '200,00' | 'Without VAT' | ''              | '200,00'     | '200,00'       | 'Store 01' |
				| 'Consignor stocks' | 'en description is empty' | 'Scarf'              | 'XS/Red'   | '15,25'      | 'pcs'  | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | 'Store 01' |
				| 'Consignor stocks' | 'en description is empty' | 'Scarf'              | 'XS/Red'   | ''           | 'pcs'  | ''                   | '2,000'    | '100,00' | 'Without VAT' | ''              | '200,00'     | '200,00'       | 'Store 01' |
		* Change inventory origin and check tax rate
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'VAT'         |
				| '3' | 'Scarf' | 'XS/Red'   | 'Without VAT' |
			And I activate "Inventory origin" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "Own stocks" exact value from "Inventory origin" drop-down list in "ItemList" table
			And "ItemList" table became equal
				| 'Price type'              | 'Item'               | 'Inventory origin' | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT'         | 'Net amount' | 'Total amount' | 'Store'    |
				| 'en description is empty' | 'Product 1 with SLN' | 'Consignor stocks' | 'PZU'      | '8908899880'         | 'pcs'  | ''           | '1,000'    | '200,00' | 'Without VAT' | '200,00'     | '200,00'       | 'Store 01' |
				| 'en description is empty' | 'Scarf'              | 'Consignor stocks' | 'XS/Red'   | ''                   | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '18%'         | '84,75'      | '100,00'       | 'Store 01' |
				| 'en description is empty' | 'Scarf'              | 'Own stocks'       | 'XS/Red'   | ''                   | 'pcs'  | '30,51'      | '2,000'    | '100,00' | '18%'         | '169,49'     | '200,00'       | 'Store 01' |		
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'VAT' |
				| '3' | 'Scarf' | 'XS/Red'   | '18%' |
			And I activate "Inventory origin" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table			
			And "ItemList" table became equal
				| 'Inventory origin' | 'Price type'              | 'Item'               | 'Item key' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Consignor stocks' | 'en description is empty' | 'Product 1 with SLN' | 'PZU'      | ''           | 'pcs'  | '8908899880'         | '1,000'    | '200,00' | 'Without VAT' | ''              | '200,00'     | '200,00'       | 'Store 01' |
				| 'Consignor stocks' | 'en description is empty' | 'Scarf'              | 'XS/Red'   | '15,25'      | 'pcs'  | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | 'Store 01' |
				| 'Consignor stocks' | 'en description is empty' | 'Scarf'              | 'XS/Red'   | ''           | 'pcs'  | ''                   | '2,000'    | '100,00' | 'Without VAT' | ''              | '200,00'     | '200,00'       | 'Store 01' |
	* Payment
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I activate "Payment type" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Cash'        |
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "500,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
				
	* Post
		And I click "Post" button
		And I delete "$$NumberRSR1$$" variable
		And I delete "$$RSR1$$" variable
		And I delete "$$DateRSR1$$" variable
		And I save the value of "Number" field as "$$NumberRSR1$$"
		And I save the window as "$$RSR1$$"
		And I save the value of the field named "Date" as "$$DateRSR1$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberRSR1$$' |
		And I close all client application windows	

Scenario: _05830 сheck recognition of own and commission goods when scanning a barcode in the SI
	* Preparation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
		If "List" table contains lines Then
			| 'Number'         |
			| '$$NumberSI10$$' |
			And I go to line in "List" table
			| 'Number'         |
			| '$$NumberSI10$$' |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso' |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01' |
		And I select current line in "List" table
	* Scan item (Dress M/Brown)
		* Own stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"
			And "ItemList" table became equal
				| '#' | 'Inventory origin' | 'Price type'        | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '1' | 'Own stocks'       | 'Basic Price Types' | 'Dress' | 'M/Brown'  | ''                   | 'No'                 | '152,54'     | 'pcs'  | ''                   | '2,000'    | '500,00' | '18%' | ''              | '847,46'     | '1 000,00'     | 'Store 01' |
		* Consignor stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"	
			And "ItemList" table became equal
				| 'Inventory origin' | 'Price type'        | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Store'    |
				| 'Own stocks'       | 'Basic Price Types' | 'Dress' | 'M/Brown'  | ''                   | 'No'                 | '152,54'     | 'pcs'  | ''                   | '2,000'    | '500,00' | '18%'         | ''              | '847,46'     | '1 000,00'     | 'No'             | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types' | 'Dress' | 'M/Brown'  | ''                   | 'No'                 | ''           | 'pcs'  | ''                   | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'No'             | 'Store 01' |
		* Over stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"				
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'        | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Dress' | 'M/Brown'  | ''                   | 'No'                 | '228,81'     | 'pcs'  | ''                   | '3,000'    | '500,00' | '18%'         | ''              | '1 271,19'   | '1 500,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress' | 'M/Brown'  | ''                   | 'No'                 | ''           | 'pcs'  | ''                   | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
	* Scan item (Dress S/Yellow)		
		* Consignor stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283713" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283713" text in the field named "InputFld"
			And I click the button named "OK"	
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'        | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Dress' | 'M/Brown'  | ''                   | 'No'                 | '228,81'     | 'pcs'  | ''                   | '3,000'    | '500,00' | '18%'         | ''              | '1 271,19'   | '1 500,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress' | 'M/Brown'  | ''                   | 'No'                 | ''           | 'pcs'  | ''                   | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress' | 'S/Yellow' | ''                   | 'No'                 | '167,80'     | 'pcs'  | ''                   | '2,000'    | '550,00' | '18%'         | ''              | '932,20'     | '1 100,00'     | 'Store 01' |
	* Scan item with serial lot number (with stock balance detail, own and consignor stock)
		* Own stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
		* Consignor stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
		* Over stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'        | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'                             | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Dress'              | 'M/Brown'  | ''                   | 'No'                 | '228,81'     | 'pcs'  | ''                                               | '3,000'    | '500,00' | '18%'         | ''              | '1 271,19'   | '1 500,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress'              | 'M/Brown'  | ''                   | 'No'                 | ''           | 'pcs'  | ''                                               | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress'              | 'S/Yellow' | ''                   | 'No'                 | '167,80'     | 'pcs'  | ''                                               | '2,000'    | '550,00' | '18%'         | ''              | '932,20'     | '1 100,00'     | 'Store 01' |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Product 3 with SLN' | 'UNIQ'     | ''                   | 'No'                 | ''           | 'pcs'  | '09987897977893; 09987897977893; 09987897977893' | '3,000'    | ''       | '18%'         | ''              | ''           | ''             | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Product 3 with SLN' | 'UNIQ'     | ''                   | 'No'                 | ''           | 'pcs'  | '09987897977893; 09987897977893'                 | '2,000'    | ''       | '18%'         | ''              | ''           | ''             | 'Store 01' |
	* Scan item with serial lot number (with stock balance detail, only consignor stock)
		* Consignor stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977894" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977894" text in the field named "InputFld"
			And I click the button named "OK"
		* Over stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977894" text in the field named "InputFld"
			And I click the button named "OK"
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'        | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'                                             | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Dress'              | 'M/Brown'  | ''                   | 'No'                 | '228,81'     | 'pcs'  | ''                                                               | '3,000'    | '500,00' | '18%'         | ''              | '1 271,19'   | '1 500,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress'              | 'M/Brown'  | ''                   | 'No'                 | ''           | 'pcs'  | ''                                                               | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress'              | 'S/Yellow' | ''                   | 'No'                 | '167,80'     | 'pcs'  | ''                                                               | '2,000'    | '550,00' | '18%'         | ''              | '932,20'     | '1 100,00'     | 'Store 01' |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Product 3 with SLN' | 'UNIQ'     | ''                   | 'No'                 | ''           | 'pcs'  | '09987897977893; 09987897977893; 09987897977893; 09987897977894' | '4,000'    | ''       | '18%'         | ''              | ''           | ''             | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Product 3 with SLN' | 'UNIQ'     | ''                   | 'No'                 | ''           | 'pcs'  | '09987897977893; 09987897977893; 09987897977894; 09987897977894' | '4,000'    | ''       | '18%'         | ''              | ''           | ''             | 'Store 01' |	
	* Scan item with serial lot number (with stock balance detail, only own stock)
		* Own stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977895" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977895" text in the field named "InputFld"
			And I click the button named "OK"
		* Over stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977895" text in the field named "InputFld"
			And I click the button named "OK"
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'        | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'                                                                                             | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Dress'              | 'M/Brown'  | ''                   | 'No'                 | '228,81'     | 'pcs'  | ''                                                                                                               | '3,000'    | '500,00' | '18%'         | ''              | '1 271,19'   | '1 500,00'     | ''                    | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress'              | 'M/Brown'  | ''                   | 'No'                 | ''           | 'pcs'  | ''                                                                                                               | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | ''                    | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress'              | 'S/Yellow' | ''                   | 'No'                 | '167,80'     | 'pcs'  | ''                                                                                                               | '2,000'    | '550,00' | '18%'         | ''              | '932,20'     | '1 100,00'     | ''                    | 'Store 01' |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Product 3 with SLN' | 'UNIQ'     | ''                   | 'No'                 | ''           | 'pcs'  | '09987897977893; 09987897977893; 09987897977893; 09987897977894; 09987897977895; 09987897977895; 09987897977895' | '7,000'    | ''       | '18%'         | ''              | ''           | ''             | ''                    | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Product 3 with SLN' | 'UNIQ'     | ''                   | 'No'                 | ''           | 'pcs'  | '09987897977893; 09987897977893; 09987897977894; 09987897977894'                                                 | '4,000'    | ''       | '18%'         | ''              | ''           | ''             | ''                    | 'Store 01' |
	* Post document
		And I go to line in "ItemList" table
			| '#' | 'Dont calculate row' | 'Inventory origin' | 'Is additional item revenue' | 'Item'               | 'Item key' |
			| '4' | 'No'                 | 'Own stocks'       | 'No'                         | 'Product 3 with SLN' | 'UNIQ'     |
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "110,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Inventory origin' | 'Item'               | 'Item key' |
			| '5' | 'Consignor stocks' | 'Product 3 with SLN' | 'UNIQ'     |
		And I select current line in "ItemList" table
		And I input "110,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberSI10$$" variable
		And I save the value of "Number" field as "$$NumberSI10$$"
		And I click "Post and close" button
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"		
		And I go to line in "List" table
			| 'Number'         |
			| '$$NumberSI10$$' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| 'Inventory origin' | 'Price type'              | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'                                                                                             | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Own stocks'       | 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | ''                   | 'No'                 | '228,81'     | 'pcs'  | ''                                                                                                               | '3,000'    | '500,00' | '18%'         | ''              | '1 271,19'   | '1 500,00'     | 'Store 01' |
			| 'Consignor stocks' | 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | ''                   | 'No'                 | ''           | 'pcs'  | ''                                                                                                               | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
			| 'Consignor stocks' | 'Basic Price Types'       | 'Dress'              | 'S/Yellow' | ''                   | 'No'                 | '167,80'     | 'pcs'  | ''                                                                                                               | '2,000'    | '550,00' | '18%'         | ''              | '932,20'     | '1 100,00'     | 'Store 01' |
			| 'Own stocks'       | 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | ''                   | 'No'                 | '117,46'     | 'pcs'  | '09987897977893; 09987897977893; 09987897977893; 09987897977894; 09987897977895; 09987897977895; 09987897977895' | '7,000'    | '110,00' | '18%'         | ''              | '652,54'     | '770,00'       | 'Store 01' |
			| 'Consignor stocks' | 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | ''                   | 'No'                 | '67,12'      | 'pcs'  | '09987897977893; 09987897977893; 09987897977894; 09987897977894'                                                 | '4,000'    | '110,00' | '18%'         | ''              | '372,88'     | '440,00'       | 'Store 01' |
		And I close all client application windows
		
				
Scenario: _05832 сheck recognition of own and commission goods when scanning a barcode in the RSR
		And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
		If "List" table contains lines Then
			| 'Number'         |
			| '$$NumberSI10$$' |
			And I go to line in "List" table
				| 'Number'         |
				| '$$NumberSI10$$' |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Open RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Filling in the details
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso' |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01' |
		And I select current line in "List" table
	* Scan item (Dress M/Brown)
		* Own stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"
			And "ItemList" table became equal
				| '#' | 'Inventory origin' | 'Price type'        | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '1' | 'Own stocks'       | 'Basic Price Types' | 'Dress' | 'M/Brown'  | 'Shop 02'            | 'No'                 | '152,54'     | 'pcs'  | ''                   | '2,000'    | '500,00' | '18%' | ''              | '847,46'     | '1 000,00'     | 'Store 01' |
		* Consignor stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"	
			And "ItemList" table became equal
				| 'Inventory origin' | 'Price type'        | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Own stocks'       | 'Basic Price Types' | 'Dress' | 'M/Brown'  | 'Shop 02'            | 'No'                 | '152,54'     | 'pcs'  | ''                   | '2,000'    | '500,00' | '18%'         | ''              | '847,46'     | '1 000,00'     | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types' | 'Dress' | 'M/Brown'  | 'Shop 02'            | 'No'                 | ''           | 'pcs'  | ''                   | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
		* Over stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"				
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'        | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Dress' | 'M/Brown'  | 'Shop 02'            | 'No'                 | '228,81'     | 'pcs'  | ''                   | '3,000'    | '500,00' | '18%'         | ''              | '1 271,19'   | '1 500,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress' | 'M/Brown'  | 'Shop 02'            | 'No'                 | ''           | 'pcs'  | ''                   | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
	* Scan item (Dress S/Yellow)		
		* Consignor stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283713" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283713" text in the field named "InputFld"
			And I click the button named "OK"	
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'        | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Dress' | 'M/Brown'  | 'Shop 02'            | 'No'                 | '228,81'     | 'pcs'  | ''                   | '3,000'    | '500,00' | '18%'         | ''              | '1 271,19'   | '1 500,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress' | 'M/Brown'  | 'Shop 02'            | 'No'                 | ''           | 'pcs'  | ''                   | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress' | 'S/Yellow' | 'Shop 02'            | 'No'                 | '167,80'     | 'pcs'  | ''                   | '2,000'    | '550,00' | '18%'         | ''              | '932,20'     | '1 100,00'     | 'Store 01' |
	* Scan item with serial lot number (with stock balance detail, own and consignor stock)
		* Own stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
		* Consignor stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
		* Over stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'        | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'                             | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Dress'              | 'M/Brown'  | 'Shop 02'            | 'No'                 | '228,81'     | 'pcs'  | ''                                               | '3,000'    | '500,00' | '18%'         | ''              | '1 271,19'   | '1 500,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress'              | 'M/Brown'  | 'Shop 02'            | 'No'                 | ''           | 'pcs'  | ''                                               | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress'              | 'S/Yellow' | 'Shop 02'            | 'No'                 | '167,80'     | 'pcs'  | ''                                               | '2,000'    | '550,00' | '18%'         | ''              | '932,20'     | '1 100,00'     | 'Store 01' |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Product 3 with SLN' | 'UNIQ'     | 'Shop 02'            | 'No'                 | ''           | 'pcs'  | '09987897977893; 09987897977893; 09987897977893' | '3,000'    | ''       | '18%'         | ''              | ''           | ''             | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Product 3 with SLN' | 'UNIQ'     | 'Shop 02'            | 'No'                 | ''           | 'pcs'  | '09987897977893; 09987897977893'                 | '2,000'    | ''       | '18%'         | ''              | ''           | ''             | 'Store 01' |
	* Scan item with serial lot number (with stock balance detail, only consignor stock)
		* Consignor stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977894" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977894" text in the field named "InputFld"
			And I click the button named "OK"
		* Over stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977894" text in the field named "InputFld"
			And I click the button named "OK"
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'        | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'                                             | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Dress'              | 'M/Brown'  | 'Shop 02'            | 'No'                 | '228,81'     | 'pcs'  | ''                                                               | '3,000'    | '500,00' | '18%'         | ''              | '1 271,19'   | '1 500,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress'              | 'M/Brown'  | 'Shop 02'            | 'No'                 | ''           | 'pcs'  | ''                                                               | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress'              | 'S/Yellow' | 'Shop 02'            | 'No'                 | '167,80'     | 'pcs'  | ''                                                               | '2,000'    | '550,00' | '18%'         | ''              | '932,20'     | '1 100,00'     | 'Store 01' |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Product 3 with SLN' | 'UNIQ'     | 'Shop 02'            | 'No'                 | ''           | 'pcs'  | '09987897977893; 09987897977893; 09987897977893; 09987897977894' | '4,000'    | ''       | '18%'         | ''              | ''           | ''             | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Product 3 with SLN' | 'UNIQ'     | 'Shop 02'            | 'No'                 | ''           | 'pcs'  | '09987897977893; 09987897977893; 09987897977894; 09987897977894' | '4,000'    | ''       | '18%'         | ''              | ''           | ''             | 'Store 01' |
	* Scan item with serial lot number (with stock balance detail, only own stock)
		* Own stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977895" text in the field named "InputFld"
			And I click the button named "OK"
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977895" text in the field named "InputFld"
			And I click the button named "OK"
		* Over stock
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "09987897977895" text in the field named "InputFld"
			And I click the button named "OK"
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'        | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'                                                                                             | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Dress'              | 'M/Brown'  | 'Shop 02'            | 'No'                 | '228,81'     | 'pcs'  | ''                                                                                                               | '3,000'    | '500,00' | '18%'         | ''              | '1 271,19'   | '1 500,00'     | ''                    | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress'              | 'M/Brown'  | 'Shop 02'            | 'No'                 | ''           | 'pcs'  | ''                                                                                                               | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | ''                    | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Dress'              | 'S/Yellow' | 'Shop 02'            | 'No'                 | '167,80'     | 'pcs'  | ''                                                                                                               | '2,000'    | '550,00' | '18%'         | ''              | '932,20'     | '1 100,00'     | ''                    | 'Store 01' |
				| 'Own stocks'       | ''             | 'Basic Price Types' | 'Product 3 with SLN' | 'UNIQ'     | 'Shop 02'            | 'No'                 | ''           | 'pcs'  | '09987897977893; 09987897977893; 09987897977893; 09987897977894; 09987897977895; 09987897977895; 09987897977895' | '7,000'    | ''       | '18%'         | ''              | ''           | ''             | ''                    | 'Store 01' |
				| 'Consignor stocks' | ''             | 'Basic Price Types' | 'Product 3 with SLN' | 'UNIQ'     | 'Shop 02'            | 'No'                 | ''           | 'pcs'  | '09987897977893; 09987897977893; 09987897977894; 09987897977894'                                                 | '4,000'    | ''       | '18%'         | ''              | ''           | ''             | ''                    | 'Store 01' |
	* Post document
		And I go to line in "ItemList" table
			| '#' | 'Dont calculate row' | 'Inventory origin' | 'Item'               | 'Item key' |
			| '4' | 'No'                 | 'Own stocks'       | 'Product 3 with SLN' | 'UNIQ'     |
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "110,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Inventory origin' | 'Item'               | 'Item key' |
			| '5' | 'Consignor stocks' | 'Product 3 with SLN' | 'UNIQ'     |
		And I select current line in "ItemList" table
		And I input "110,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I activate "Payment type" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Cash'        |
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "4 810,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table		
		And I click "Post" button
		And I delete "$$NumberRSR10$$" variable
		And I save the value of "Number" field as "$$NumberRSR10$$"
		And I click "Post and close" button
	* Check creation
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"		
		And I go to line in "List" table
			| 'Number'         |
			| '$$NumberRSR10$$' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| 'Inventory origin' | 'Price type'              | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'                                                                                             | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Own stocks'       | 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | 'Shop 02'            | 'No'                 | '228,81'     | 'pcs'  | ''                                                                                                               | '3,000'    | '500,00' | '18%'         | ''              | '1 271,19'   | '1 500,00'     | 'Store 01' |
			| 'Consignor stocks' | 'Basic Price Types'       | 'Dress'              | 'M/Brown'  | 'Shop 02'            | 'No'                 | ''           | 'pcs'  | ''                                                                                                               | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
			| 'Consignor stocks' | 'Basic Price Types'       | 'Dress'              | 'S/Yellow' | 'Shop 02'            | 'No'                 | '167,80'     | 'pcs'  | ''                                                                                                               | '2,000'    | '550,00' | '18%'         | ''              | '932,20'     | '1 100,00'     | 'Store 01' |
			| 'Own stocks'       | 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | 'Shop 02'            | 'No'                 | '117,46'     | 'pcs'  | '09987897977893; 09987897977893; 09987897977893; 09987897977894; 09987897977895; 09987897977895; 09987897977895' | '7,000'    | '110,00' | '18%'         | ''              | '652,54'     | '770,00'       | 'Store 01' |
			| 'Consignor stocks' | 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | 'Shop 02'            | 'No'                 | '67,12'      | 'pcs'  | '09987897977893; 09987897977893; 09987897977894; 09987897977894'                                                 | '4,000'    | '110,00' | '18%'         | ''              | '372,88'     | '440,00'       | 'Store 01' |
		And I close all client application windows
				


Scenario: _05834 сheck recognition of own and commission goods when scanning a barcode in the POS
		And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"	
		If "List" table contains lines Then
			| 'Number'          |
			| '$$NumberRSR10$$' |
			And I go to line in "List" table
				| 'Number'          |
				| '$$NumberRSR10$$' |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"	
		And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
		Then "Point of sales" window is opened
	* Scan item (Dress M/Brown)
		* Own stock
			And I click "Search by barcode (F7)" button
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"
			And I click "Search by barcode (F7)" button
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"
		* Consignor stock
			And I click "Search by barcode (F7)" button
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"
			And I click "Search by barcode (F7)" button
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"	
		* Over stock
			And I click "Search by barcode (F7)" button
			And I input "2202283714" text in the field named "InputFld"
			And I click the button named "OK"				
	* Scan item (Dress S/Yellow)		
		* Consignor stock
			And I click "Search by barcode (F7)" button
			And I input "2202283713" text in the field named "InputFld"
			And I click the button named "OK"
			And I click "Search by barcode (F7)" button
			And I input "2202283713" text in the field named "InputFld"
			And I click the button named "OK"	
	* Scan item with serial lot number (with stock balance detail, own and consignor stock)
		* Own stock
			And I click "Search by barcode (F7)" button
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
			And I click "Search by barcode (F7)" button
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
		* Consignor stock
			And I click "Search by barcode (F7)" button
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
			And I click "Search by barcode (F7)" button
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
		* Over stock
			And I click "Search by barcode (F7)" button
			And I input "09987897977893" text in the field named "InputFld"
			And I click the button named "OK"
	* Scan item with serial lot number (with stock balance detail, only consignor stock)
		* Consignor stock
			And I click "Search by barcode (F7)" button
			And I input "09987897977894" text in the field named "InputFld"
			And I click the button named "OK"
			And I click "Search by barcode (F7)" button
			And I input "09987897977894" text in the field named "InputFld"
			And I click the button named "OK"
		* Over stock
			And I click "Search by barcode (F7)" button
			And I input "09987897977894" text in the field named "InputFld"
			And I click the button named "OK"
	* Scan item with serial lot number (with stock balance detail, only own stock)
		* Own stock
			And I click "Search by barcode (F7)" button
			And I input "09987897977895" text in the field named "InputFld"
			And I click the button named "OK"
			And I click "Search by barcode (F7)" button
			And I input "09987897977895" text in the field named "InputFld"
			And I click the button named "OK"
		* Over stock
			And I click "Search by barcode (F7)" button
			And I input "09987897977895" text in the field named "InputFld"
			And I click the button named "OK"
	* Price
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' | 'Quantity' | 'Serials'                                                                                                        |
			| 'Product 3 with SLN' | 'UNIQ'     | '7,000'    | '09987897977893; 09987897977893; 09987897977893; 09987897977894; 09987897977895; 09987897977895; 09987897977895' |
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' | 'Quantity' | 'Serials'                                                        |
			| 'Product 3 with SLN' | 'UNIQ'     | '4,000'    | '09987897977893; 09987897977893; 09987897977894; 09987897977894' |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check filling
		And "ItemList" table became equal
			| 'Item'               | 'Sales person' | 'Item key' | 'Serials'                                                                                                        | 'Price'  | 'Quantity' | 'Offers' | 'Total'    |
			| 'Dress'              | ''             | 'M/Brown'  | ''                                                                                                               | '500,00' | '3,000'    | ''       | '1 500,00' |
			| 'Dress'              | ''             | 'M/Brown'  | ''                                                                                                               | '500,00' | '2,000'    | ''       | '1 000,00' |
			| 'Dress'              | ''             | 'S/Yellow' | ''                                                                                                               | '550,00' | '2,000'    | ''       | '1 100,00' |
			| 'Product 3 with SLN' | ''             | 'UNIQ'     | '09987897977893; 09987897977893; 09987897977893; 09987897977894; 09987897977895; 09987897977895; 09987897977895' | '200,00' | '7,000'    | ''       | '1 400,00' |
			| 'Product 3 with SLN' | ''             | 'UNIQ'     | '09987897977893; 09987897977893; 09987897977894; 09987897977894'                                                 | '300,00' | '4,000'    | ''       | '1 200,00' |
	* Payment
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click "Cash (/)" button
		And I click the button named "Enter"
	* Check filling Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"	
		And I go to line in "List" table
			| 'Σ'        |
			| '6 200,00' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| 'Price type'              | 'Item'               | 'Inventory origin' | 'Profit loss center' | 'Item key' | 'Dont calculate row' | 'Serial lot numbers'                                                                                             | 'Unit' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Basic Price Types'       | 'Dress'              | 'Own stocks'       | 'Shop 02'            | 'M/Brown'  | 'No'                 | ''                                                                                                               | 'pcs'  | '228,81'     | '3,000'    | '500,00' | '18%'         | ''              | '1 271,19'   | '1 500,00'     | 'Store 01' |
			| 'Basic Price Types'       | 'Dress'              | 'Consignor stocks' | 'Shop 02'            | 'M/Brown'  | 'No'                 | ''                                                                                                               | 'pcs'  | ''           | '2,000'    | '500,00' | 'Without VAT' | ''              | '1 000,00'   | '1 000,00'     | 'Store 01' |
			| 'Basic Price Types'       | 'Dress'              | 'Consignor stocks' | 'Shop 02'            | 'S/Yellow' | 'No'                 | ''                                                                                                               | 'pcs'  | '167,80'     | '2,000'    | '550,00' | '18%'         | ''              | '932,20'     | '1 100,00'     | 'Store 01' |
			| 'en description is empty' | 'Product 3 with SLN' | 'Own stocks'       | 'Shop 02'            | 'UNIQ'     | 'No'                 | '09987897977893; 09987897977893; 09987897977893; 09987897977894; 09987897977895; 09987897977895; 09987897977895' | 'pcs'  | '213,56'     | '7,000'    | '200,00' | '18%'         | ''              | '1 186,44'   | '1 400,00'     | 'Store 01' |
			| 'en description is empty' | 'Product 3 with SLN' | 'Consignor stocks' | 'Shop 02'            | 'UNIQ'     | 'No'                 | '09987897977893; 09987897977893; 09987897977894; 09987897977894'                                                 | 'pcs'  | '183,05'     | '4,000'    | '300,00' | '18%'         | ''              | '1 016,95'   | '1 200,00'     | 'Store 01' |
		And I close all client application windows
		
				
				
					
				



		
				



				
				


	



				
				


