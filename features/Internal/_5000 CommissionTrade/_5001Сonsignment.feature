#language: en

@tree
@Positive
@CommissionTrade


Feature: consignment



Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _05002 preparation (consignment)
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
		When Create catalog SerialLotNumbers objects (serial lot numbers, with batch balance details)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog Countries objects
		When Create catalog SourceOfOrigins objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Users objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Agreements objects (commision trade, own companies)
		When Create information register TaxSettings records (Concignor 1)
		When Create catalog Companies objects (Main company)
		When Create catalog Companies objects (own Second company)
		When Create catalog Stores objects
		When Create catalog Stores (trade agent)
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Items objects (commission trade)
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
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When update ItemKeys
		When update ItemKeys
		When Create catalog Partners objects
		When Data preparation (comission stock)
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"            |
				| "TaxCalculateVAT_TR"     |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)
	* Tax settings
		When filling in Tax settings for company
		When Create information register TaxSettings records (Concignor 2)
	* Post document
		And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(192).GetObject().Write(DocumentWriteMode.Posting);"     |
	* Setting for Company
		When settings for Company (commission trade)
	And I close all client application windows

Scenario: _050002 check preparation
	When check preparation

Scenario: _050003 create SI (Shipment to trade agent)
		And I close all client application windows
	* Open SI form
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I select "Shipment to trade agent" exact value from "Transaction type" drop-down list
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And "List" table does not contain lines
			| 'Description'    |
			| 'Ferron BP'      |
		And I go to line in "List" table
			| 'Description'      |
			| 'Trade agent 1'    |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
	* Check filling legal name, partner term, company, store
		Then the form attribute named "Partner" became equal to "Trade agent 1"
		Then the form attribute named "LegalName" became equal to "Trade agent 1"
		Then the form attribute named "Agreement" became equal to "Trade agent partner term 1"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Shipment to trade agent"
		Then the form attribute named "Store" became equal to "Store 02"
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Code'   | 'Description'          |
			| '161'    | 'Product 1 with SLN'   |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Code'   | 'Item'                 | 'Item key'    |
			| '35'     | 'Product 1 with SLN'   | 'PZU'         |
		And I select current line in "List" table
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner'   | 'Serial number'    |
			| 'PZU'     | '8908899879'       |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		Then "Item serial/lot numbers" window is opened
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner'   | 'Serial number'    |
			| 'PZU'     | '8908899877'       |
		And I select current line in "List" table
		And I finish line editing in "SerialLotNumbers" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Code'   | 'Description'          |
			| '164'    | 'Product 4 with SLN'   |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Code'   | 'Item'                 | 'Item key'    |
			| '41'     | 'Product 4 with SLN'   | 'UNIQ'        |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I activate "Serial number" field in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I activate "Price" field in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'   | 'Dont calculate row'   | 'Is additional item revenue'   | 'Item'                 | 'Item key'   | 'Price type'          | 'Quantity'   | 'Serial lot numbers'       | 'Store'      | 'Unit'   | 'Use shipment confirmation'   | 'Use work sheet'   | 'VAT'    |
			| '1'   | 'No'                   | 'No'                           | 'Product 1 with SLN'   | 'PZU'        | 'Basic Price Types'   | '4,000'      | '8908899879; 8908899877'   | 'Store 02'   | 'pcs'    | 'Yes'                         | 'No'               | '18%'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Code'   | 'Description'   |
			| '1'      | 'Dress'         |
		And I select current line in "List" table
		Then "Sales invoice (create) *" window is opened
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Code'   | 'Item'    | 'Item key'    |
			| '2'      | 'Dress'   | 'XS/Blue'     |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I input "4,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Code'   | 'Description'   |
			| '4'      | 'Boots'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Code'   | 'Item'    | 'Item key'    |
			| '15'     | 'Boots'   | '37/18SD'     |
		And I activate field named "ItemKey" in "List" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Change store
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button	
	* Check item tab
		And "ItemList" table became equal
			| 'Price type'                | 'Item'                 | 'Item key'   | 'Profit loss center'   | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Serial lot numbers'       | 'Quantity'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Is additional item revenue'   | 'Additional analytic'   | 'Store'      | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'   | 'Revenue type'   | 'Sales person'    |
			| 'en description is empty'   | 'Product 1 with SLN'   | 'PZU'        | ''                     | 'No'                   | '61,02'        | 'pcs'    | '8908899879; 8908899877'   | '4,000'      | '100,00'   | '18%'   | ''                | '338,98'       | '400,00'         | 'No'                           | ''                      | 'Store 01'   | ''                | 'No'                          | ''         | ''              | ''               | ''                |
			| 'en description is empty'   | 'Product 4 with SLN'   | 'UNIQ'       | ''                     | 'No'                   | '61,02'        | 'pcs'    | '899007790088'             | '2,000'      | '200,00'   | '18%'   | ''                | '338,98'       | '400,00'         | 'No'                           | ''                      | 'Store 01'   | ''                | 'No'                          | ''         | ''              | ''               | ''                |
			| 'Basic Price Types'         | 'Dress'                | 'XS/Blue'    | ''                     | 'No'                   | '317,29'       | 'pcs'    | ''                         | '4,000'      | '520,00'   | '18%'   | ''                | '1 762,71'     | '2 080,00'       | 'No'                           | ''                      | 'Store 01'   | ''                | 'No'                          | ''         | ''              | ''               | ''                |
			| 'Basic Price Types'         | 'Boots'                | '37/18SD'    | ''                     | 'No'                   | '106,78'       | 'pcs'    | ''                         | '1,000'      | '700,00'   | '18%'   | ''                | '593,22'       | '700,00'         | 'No'                           | ''                      | 'Store 01'   | ''                | 'No'                          | ''         | ''              | ''               | ''                |
	* Fill branch and post SI
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		Then "Business units" window is opened
		And I go to line in "List" table
			| 'Code'   | 'Department'   | 'Description'               | 'Workshop'    |
			| '3'      | 'Yes'          | 'Distribution department'   | 'No'          |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I click "Post" button
		And I delete "$$NumberSI050003$$" variable
		And I delete "$$SI050003$$" variable
		And I delete "$$DateSI050003$$" variable
		And I save the value of "Number" field as "$$NumberSI050003$$"
		And I save the window as "$$SI050003$$"
		And I save the value of the field named "Date" as "$$DateSI050003$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'                |
			| '$$NumberSI050003$$'    |
		And I close all client application windows