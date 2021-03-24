#language: en
@tree
@Positive
@LinkedTransaction

Feature: link unlink form



Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _2060001 preparation
	When set True value to the constant
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
	When Create document PurchaseInvoice objects (linked)
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
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
			| "Documents.SalesInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(103).GetObject().Write(DocumentWriteMode.Posting);" |
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
	
Scenario: _2060002 check link/unlink form in the SC
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
	* Select items from basis documents
		And I click "AddBasisDocuments" button
		And I expand current line in "BasisesTree" table
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                            | 'Use'                                         |
			| 'Sales invoice 102 dated 05.03.2021 12:57:59' | 'Sales invoice 102 dated 05.03.2021 12:57:59' |
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                            | 'Use'                                         |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' | 'Sales invoice 103 dated 05.03.2021 12:59:44' |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '700,00' | '2,000'    | 'Boots, 37/18SD'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '440,68' | '8,000'    | 'Dress, M/White'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '648,15' | '2,000'    | 'Boots, 37/18SD'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Show row key" button
	* Check RowIDInfo
		And "RowIDInfo" table contains lines
		| '#' | 'Basis'                                       | 'Next step' | 'Q'     | 'Current step' |
		| '1' | 'Sales invoice 103 dated 05.03.2021 12:59:44' | ''          | '8,000' | 'SC'           |
		| '2' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''          | '2,000' | 'SC'           |
		| '3' | 'Sales invoice 103 dated 05.03.2021 12:59:44' | ''          | '2,000' | 'SC'           |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Unlink line
		And I click "LinkUnlinkBasisDocuments" button
		Then "Link / unlink document row" window is opened
		And I expand a line in "ResultsTree" table
			| 'Row presentation'                            |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' |
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '3' | '2,000'    | 'Boots, 37/18SD'   | 'Store 02' | 'pcs'  |
		And I expand a line in "ResultsTree" table
			| 'Row presentation'                            |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "ResultsTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '648,15' | '2,000'    | 'Boots, 37/18SD'   | 'pcs'  |
		And I click "Unlink" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Sales invoice'                               |
			| 'Dress' | 'M/White'  | 'Sales invoice 103 dated 05.03.2021 12:59:44' |
			| 'Boots' | '37/18SD'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' |
			| 'Boots' | '37/18SD'  | ''                                            |
	* Link line
		And I click "LinkUnlinkBasisDocuments" button
		And I expand a line in "ResultsTree" table
			| 'Row presentation'                            |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' |
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '3' | '2,000'    | 'Boots, 37/18SD'   | 'Store 02' | 'pcs'  |
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                            |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '648,15' | '2,000'    | 'Boots, 37/18SD'   | 'pcs'  |
		And I click "Link" button
		And I click "Ok" button
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                       | 'Next step' | 'Q'     | 'Current step' |
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
		And I click "AddBasisDocuments" button
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '648,15' | '2,000'    | 'Boots, 37/18SD'   | 'pcs'  | 'No'  |
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
			| '#' | 'Basis'                                       | 'Next step' | 'Q'     | 'Current step' |
			| '1' | 'Sales invoice 103 dated 05.03.2021 12:59:44' | ''          | '8,000' | 'SC'           |
			| '2' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''          | '2,000' | 'SC'           |
			| '3' | 'Sales invoice 103 dated 05.03.2021 12:59:44' | ''          | '24,000' | 'SC'          |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I close all client application windows
		
		
				

		
				
		
				
		
				
		
		
			

