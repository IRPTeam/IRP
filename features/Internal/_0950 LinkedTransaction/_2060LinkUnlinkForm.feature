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
		When Create Document discount
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
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
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
	When Create document SalesOrder objects (SI before SC, not Use shipment sheduling)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(31).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
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
	When create GoodsReceipt and PurchaseOrder objects (select from basis in the PI)
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(1051).GetObject().Write(DocumentWriteMode.Posting);"|
			| "Documents.GoodsReceipt.FindByNumber(1051).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.GoodsReceipt.FindByNumber(1052).GetObject().Write(DocumentWriteMode.Posting);" |
	When create ShipmentConfirmation and SalesOrder objects (select from basis in the PI)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1051).GetObject().Write(DocumentWriteMode.Posting);"|
			| "Documents.ShipmentConfirmation.FindByNumber(1051).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.ShipmentConfirmation.FindByNumber(1052).GetObject().Write(DocumentWriteMode.Posting);" |	
			
	
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
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table		
	* Select items from basis documents
		And I click "AddBasisDocuments" button
		And I expand current line in "BasisesTree" table
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                            | 'Use'                                         |
			| 'Sales invoice 102 dated 05.03.2021 12:57:59' | 'No' |
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                            | 'Use'                                         |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' | 'No' |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '700,00' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '440,68' | '8,000'    | 'Dress (M/White)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '648,15' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  | 'No'  |
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
		And I set checkbox "Linked documents"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '3' | '2,000'    | 'Boots (37/18SD)'   | 'Store 02' | 'pcs'  |
		And I expand a line in "ResultsTree" table
			| 'Row presentation'                            |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "ResultsTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '648,15' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  |
		And I click "Unlink" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Sales invoice'                               |
			| 'Dress' | 'M/White'  | 'Sales invoice 103 dated 05.03.2021 12:59:44' |
			| 'Boots' | '37/18SD'  | 'Sales invoice 101 dated 05.03.2021 12:56:38' |
			| 'Boots' | '37/18SD'  | ''                                            |
	* Link line
		And I click "LinkUnlinkBasisDocuments" button
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '3' | '2,000'    | 'Boots (37/18SD)'   | 'Store 02' | 'pcs'  |
		And I set checkbox "Linked documents"
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                            |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '648,15' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  |
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
			| 'TRY'      | '648,15' | '2,000'    | 'Boots (37/18SD)'   | 'pcs'  | 'No'  |
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
	* Add all items from SI
		And I click "AddBasisDocuments" button
		And I go to line in "BasisesTree" table
			| 'Row presentation'                            | 'Use' |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Store'    | 'Item'  | 'Item key' | 'Quantity' | 'Sales invoice'                               | 'Unit'           |
			| 'Store 02' | 'Dress' | 'M/White'  | '8,000'    | 'Sales invoice 103 dated 05.03.2021 12:59:44' | 'pcs'            |
			| 'Store 01' | 'Boots' | '37/18SD'  | '2,000'    | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'pcs'            |
			| 'Store 02' | 'Boots' | '37/18SD'  | '2,000'    | 'Sales invoice 103 dated 05.03.2021 12:59:44' | 'Boots (12 pcs)' |
			| 'Store 02' | 'Boots' | '36/18SD'  | '2,000'    | 'Sales invoice 103 dated 05.03.2021 12:59:44' | 'Boots (12 pcs)' |
			| 'Store 02' | 'Dress' | 'S/Yellow' | '8,000'    | 'Sales invoice 103 dated 05.03.2021 12:59:44' | 'pcs'            |
	* Unlink all lines
		And I click "LinkUnlinkBasisDocuments" button
		And I set checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And "BasisesTree" table became equal
			| 'Row presentation'                            | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales invoice 103 dated 05.03.2021 12:59:44' | ''         | ''     | ''       | ''         |
			| 'Dress (M/White)'                             | '8,000'    | 'pcs'  | '440,68' | 'TRY'      |
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Store'    | 'Item'  | 'Item key' | 'Quantity' | 'Sales invoice' | 'Unit'           |
			| 'Store 02' | 'Dress' | 'M/White'  | '8,000'    | ''              | 'pcs'            |
			| 'Store 01' | 'Boots' | '37/18SD'  | '2,000'    | ''              | 'pcs'            |
			| 'Store 02' | 'Boots' | '37/18SD'  | '2,000'    | ''              | 'Boots (12 pcs)' |
			| 'Store 02' | 'Boots' | '36/18SD'  | '2,000'    | ''              | 'Boots (12 pcs)' |
			| 'Store 02' | 'Dress' | 'S/Yellow' | '8,000'    | ''              | 'pcs'            |
		And I close all client application windows
		
		
Scenario: _2060003 check auto link button in the SI
	* Open form for create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
	* Add items	
		* One SO - 1 pcs, second SO - 1 pcs
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
		* One SO - 10 pcs, second SO - 10 pcs
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '36/Red'  |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
		* One SO - 1 pcs, second SO - 1 pcs
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Service'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'    | 'Item key' |
				| 'Service' | 'Interner' |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
		* More than in SO, only one line
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD' |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "65,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
	* Auto link
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I click "Auto link" button
		And I click "Ok" button
	* Check auto link
		And "ItemList" table contains lines
			| '#' | 'SalesTax' | 'Revenue type' | 'Price type'              | 'Item'    | 'Item key' | 'Profit loss center'      | 'Dont calculate row' | 'Serial lot numbers' | 'Q'      | 'Unit' | 'Tax amount' | 'Price'    | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order'                             |
			| '1' | ''         | 'Revenue'      | 'Basic Price Types'       | 'Dress'   | 'XS/Blue'  | 'Distribution department' | 'No'                 | ''                   | '2,000'  | 'pcs'  | '150,72'     | '520,00'   | '18%' | '52,00'         | '837,28'     | '988,00'       | ''                    | 'Store 02' | '27.01.2021'    | 'Yes'                       | ''       | 'Sales order 3 dated 27.01.2021 19:50:45' |
			| '2' | ''         | 'Revenue'      | 'Basic Price Types'       | 'Shirt'   | '36/Red'   | 'Distribution department' | 'No'                 | ''                   | '10,000' | 'pcs'  | '507,20'     | '350,00'   | '18%' | '175,00'        | '2 817,80'   | '3 325,00'     | ''                    | 'Store 02' | '27.01.2021'    | 'Yes'                       | ''       | 'Sales order 3 dated 27.01.2021 19:50:45' |
			| '3' | ''         | 'Revenue'      | 'en description is empty' | 'Service' | 'Interner' | 'Front office'            | 'No'                 | ''                   | '1,000'  | 'pcs'  | '14,49'      | '100,00'   | '18%' | '5,00'          | '80,51'      | '95,00'        | ''                    | 'Store 02' | '27.01.2021'    | 'No'                        | ''       | 'Sales order 3 dated 27.01.2021 19:50:45' |
			| '4' | ''         | 'Revenue'      | 'Basic Price Types'       | 'Boots'   | '36/18SD'  | 'Front office'            | 'No'                 | ''                   | '65,000' | 'pcs'  | '6 940,68'   | '8 400,00' | '18%' | ''              | '38 559,32'  | '45 500,00'    | ''                    | 'Store 02' | '27.01.2021'    | 'Yes'                       | ''       | 'Sales order 3 dated 27.01.2021 19:50:45' |
		Then the number of "ItemList" table lines is "равно" "4"
		And I close all client application windows
		
Scenario: _2060007 select items from basis documents in the PI
	* Open form for create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor DFC'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'  |
		And I select current line in "List" table
	* Select items from basis documents
		And I click "Add basis documents" button
		And I expand current line in "BasisesTree" table
		And "BasisesTree" table contains lines 
			| 'Row presentation'                               | 'Use' | 'Quantity' | 'Unit'           | 'Price'    | 'Currency' |
			| 'Sales order 31 dated 27.01.2021 19:50:45'       | 'No'  | ''         | ''               | ''         | ''         |
			| 'Boots (37/18SD)'                                | 'No'  | '2,000'    | 'Boots (12 pcs)' | '8 400,00' | 'TRY'      |
			| 'Purchase order 1 051 dated 20.07.2021 10:22:16' | 'No'  | ''         | ''               | ''         | ''         |
			| 'Dress (S/Yellow)'                               | 'No'  | '55,000'   | 'pcs'            | '550,00'   | 'TRY'      |
			| 'Dress (XS/Blue)'                                | 'No'  | '250,000'  | 'pcs'            | '520,00'   | 'TRY'      |
			| 'Goods receipt 1 051 dated 20.07.2021 10:23:22'  | 'No'  | ''         | ''               | ''         | ''         |
			| 'Dress (S/Yellow)'                               | 'No'  | '45,000'   | 'pcs'            | '550,00'   | 'TRY'      |
			| 'Dress (XS/Blue)'                                | 'No'  | '750,000'  | 'pcs'            | '520,00'   | 'TRY'      |
			| 'Goods receipt 1 052 dated 20.07.2021 10:23:55'  | 'No'  | ''         | ''               | ''         | ''         |
			| 'Dress (S/Yellow)'                               | 'No'  | '5,000'    | 'pcs'            | ''         | ''         |
			| 'Dress (XS/Blue)'                                | 'No'  | '50,000'   | 'pcs'            | ''         | ''         |
			| 'Trousers (36/Yellow)'                            | 'No'  | '40,000'   | 'pcs'            | ''         | ''         |
		Then the number of "BasisesTree" table lines is "равно" "12"
		And I close all client application windows



Scenario: _2060010 select items from basis documents in the SI
	* Open form for create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	* Select items from basis documents
		And I click "Add basis documents" button
		And I expand current line in "BasisesTree" table
		And "BasisesTree" table contains lines 
			| 'Row presentation'                                   | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11'        | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | '55,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | '250,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 051 dated 20.07.2021 10:44' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | '45,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | '750,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 052 dated 20.07.2021 10:44' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | '5,000'    | 'pcs'  | ''       | ''         |
			| 'Dress (S/Yellow)'                                    | '100,000'  | 'pcs'  | ''       | ''         |
		Then the number of "BasisesTree" table lines is "равно" "9"
		And I close all client application windows

Scenario: _2060015 check form select items from basis documents in the SI
	* Open form for create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table		
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	* Select items from basis documents
		And I click "Add basis documents" button
		And I expand current line in "BasisesTree" table
		And "BasisesTree" table contains lines
			| 'Row presentation'                                   | 'Use' | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11'        | 'No'  | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'No'  | '55,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'No'  | '250,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 051 dated 20.07.2021 10:44' | 'No'  | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'No'  | '45,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'No'  | '750,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 052 dated 20.07.2021 10:44' | 'No'  | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'No'  | '5,000'    | 'pcs'  | ''       | ''         |
			| 'Dress (S/Yellow)'                                    | 'No'  | '100,000'  | 'pcs'  | ''       | ''         |
	* Check use/unused all related documents
		And I go to line in "BasisesTree" table
			| 'Row presentation'                            | 'Use' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11' | 'No'  |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And "BasisesTree" table contains lines
			| 'Row presentation'                                   | 'Use' | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11'        | 'Yes' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'Yes' | '55,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'Yes' | '250,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 051 dated 20.07.2021 10:44' | 'Yes' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'Yes' | '45,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'Yes' | '750,000'  | 'pcs'  | '550,00' | 'TRY'      |
		And I go to line in "BasisesTree" table
			| 'Row presentation'                                   | 'Use' |
			| 'Shipment confirmation 1 051 dated 20.07.2021 10:44' | 'Yes' |
		And I remove "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And "BasisesTree" table contains lines
			| 'Row presentation'                                   | 'Use' | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11'        | 'Yes' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'Yes' | '55,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'Yes' | '250,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 051 dated 20.07.2021 10:44' | 'No'  | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'No'  | '45,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'No'  | '750,000'  | 'pcs'  | '550,00' | 'TRY'      |
		And I go to line in "BasisesTree" table
			| 'Row presentation'                                   | 'Use' |
			| 'Shipment confirmation 1 052 dated 20.07.2021 10:44' | 'No'  |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Row presentation'                            | 'Use' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11' | 'Yes' |
		And I remove "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And "BasisesTree" table contains lines
			| 'Row presentation'                                   | 'Use' | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 1 051 dated 20.07.2021 10:44:11'        | 'No'  | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'No'  | '55,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'No'  | '250,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 051 dated 20.07.2021 10:44' | 'No'  | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'No'  | '45,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (S/Yellow)'                                    | 'No'  | '750,000'  | 'pcs'  | '550,00' | 'TRY'      |
			| 'Shipment confirmation 1 052 dated 20.07.2021 10:44' | 'Yes' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                     | 'Yes' | '5,000'    | 'pcs'  | ''       | ''         |
			| 'Dress (S/Yellow)'                                    | 'Yes' | '100,000'  | 'pcs'  | ''       | ''         |
		And I close all client application windows

Scenario: _2060020 check button Show quantity in base unit in the Link form
	* Open form for create SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
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
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table	
	* Filling in Item tab
		And I move to "Items" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate field named "ItemKey" in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots (12 pcs)' |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I activate field named "Item" in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'box Dress (8 pcs)' |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
	* Check button Show quantity in base unit in the Link form
		And I click "LinkUnlinkBasisDocuments" button
		And I set checkbox "Show quantity in basis unit"
		And "ItemListRows" table contains lines
			| 'Row presentation' | 'Unit'              | 'Quantity' | 'Unit (basis)' | 'Quantity (basis)' | 'Store'    |
			| 'Boots (37/18SD)'  | 'Boots (12 pcs)'    | '2,000'    | 'pcs'          | '24,000'           | 'Store 01' |
			| 'Dress (XS/Blue)'  | 'box Dress (8 pcs)' | '2,000'    | 'pcs'          | '16,000'           | 'Store 01' |
		And I close all client application windows
			
		
		
				

		
				

		
					

		
				