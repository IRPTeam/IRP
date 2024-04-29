#language: en
@tree
@Positive
@LoadInfo

Functionality: load data form

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _020100 preparation (LoadDataForm)
	When set True value to the constant
	When set True value to the constant Use commission trading 
	* Load info
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BusinessUnits objects
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Countries objects
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Items objects (serial lot numbers)
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Users objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog FileStorageVolumes objects
		When Create catalog Files objects
		When Create information register Taxes records (VAT)

Scenario: _0201001 check preparation
	When check preparation

Scenario: _020110 load data in the SI
		And I close all client application windows
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling SI
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| '#'   | 'Price type'          | 'Item'                 | 'Item key'   | 'Profit loss center'   | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Serial lot numbers'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Other period revenue type'   | 'Additional analytic'   | 'Store'      | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'   | 'Revenue type'   | 'Sales person'    |
			| '1'   | 'Basic Price Types'   | 'Dress'                | 'XS/Blue'    | ''                     | 'No'                   | '475,93'       | 'pcs'    | ''                     | '6,000'      | '520,00'   | '18%'   | ''                | '2 644,07'     | '3 120,00'       | ''                     | ''                      | 'Store 01'   | ''                | 'No'                          | ''         | ''              | ''               | ''                |
			| '2'   | 'Basic Price Types'   | 'Product 1 with SLN'   | 'ODS'        | ''                     | 'No'                   | ''             | 'pcs'    | ''                     | '2,000'      | ''         | '18%'   | ''                | ''             | ''               | ''                     | ''                      | 'Store 01'   | ''                | 'No'                          | ''         | ''              | ''               | ''                |
			| '3'   | 'Basic Price Types'   | 'Product 1 with SLN'   | 'PZU'        | ''                     | 'No'                   | ''             | 'pcs'    | '8908899877'           | '1,000'      | ''         | '18%'   | ''                | ''             | ''               | ''                     | ''                      | 'Store 01'   | ''                | 'No'                          | ''         | ''              | ''               | ''                |
			| '4'   | 'Basic Price Types'   | 'Dress'                | 'S/Yellow'   | ''                     | 'No'                   | '251,69'       | 'pcs'    | ''                     | '3,000'      | '550,00'   | '18%'   | ''                | '1 398,31'     | '1 650,00'       | ''                     | ''                      | 'Store 01'   | ''                | 'No'                          | ''         | ''              | ''               | ''                |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Price"
		And I set checkbox "Delivery date"
		And I set checkbox "Detail"
		And I click "Next" button
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then the form attribute named "ShowImage" became equal to "No"
		Then the form attribute named "Field_Price" became equal to "Yes"
		Then the form attribute named "Field_OffersAmount" became equal to "No"
		Then the form attribute named "Field_TaxAmount" became equal to "No"
		Then the form attribute named "Field_NetAmount" became equal to "No"
		Then the form attribute named "Field_TotalAmount" became equal to "No"
		Then the form attribute named "Field_DeliveryDate" became equal to "Yes"
		Then the form attribute named "Field_Detail" became equal to "Yes"
		And I close all client application windows
			

Scenario: _020111 load data in the SI by serial lot number
	And I close all client application windows
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling SI
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
	* Load type by serial lot number
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Price"
		And I set checkbox "Delivery date"
		And I set checkbox "Detail"
		And I click "Next" button
		And I change "Load type" radio button value to "Serial lot number"
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I input text "09987897977889"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And in "Template" spreadsheet document I move to "R3C3" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "200"
		And in "Template" spreadsheet document I move to "R3C4" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "20250312"
		And in "Template" spreadsheet document I move to "R3C5" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "test"
		And I click "Next" button
		And I click "Next" button
		And "ItemList" table became equal
			| '#'   | 'Inventory origin'   | 'Price type'          | 'Item'                 | 'Item key'   | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Serial lot numbers'   | 'Source of origins'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Other period revenue type'   | 'Store'      | 'Delivery date'   | 'Detail'    |
			| '1'   | 'Own stocks'         | 'Basic Price Types'   | 'Product 3 with SLN'   | 'UNIQ'       | 'No'                   | '61,02'        | 'pcs'    | '09987897977889'       | ''                    | '2,000'      | '200,00'   | '18%'   | ''                | '338,98'       | '400,00'         | ''                     | 'Store 01'   | '12.03.2025'      | 'test'      |
		And I close all client application windows
		
Scenario: _020111 load data in the SI by item and item key
	And I close all client application windows
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling SI
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
	* Load type by serial lot number
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Price"
		And I set checkbox "Detail"
		And I click "Next" button
		And I change "Load type" radio button value to "Item / Item key"
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I input text "Product 1 with SLN"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "ODS"
		And in "Template" spreadsheet document I move to "R3C3" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And in "Template" spreadsheet document I move to "R3C4" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "200"
		And in "Template" spreadsheet document I move to "R3C5" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "test"
		And I click "Next" button
		And I click "Next" button
		And "ItemList" table became equal
			| '#'   | 'Inventory origin'   | 'Price type'          | 'Item'                 | 'Item key'   | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Serial lot numbers'   | 'Source of origins'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Other period revenue type'   | 'Store'      | 'Delivery date'   | 'Detail'    |
			| '1'   | 'Own stocks'         | 'Basic Price Types'   | 'Product 1 with SLN'   | 'ODS'        | 'No'                   | '61,02'        | 'pcs'    | ''                     | ''                    | '2,000'      | '200,00'   | '18%'   | ''                | '338,98'       | '400,00'         | ''                     | 'Store 01'   | ''                | 'test'      |
		And I close all client application windows
		
		

Scenario: _020112 load data in the Physical inventory
		And I close all client application windows
	* Open Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
	* Filling Physical inventory
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I set checkbox "Use serial lot"	
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table became equal
			| '#'   | 'Exp. count'   | 'Item'                 | 'Item key'   | 'Serial lot number'   | 'Unit'   | 'Difference'   | 'Phys. count'   | 'Manual fixed count'   | 'Description'    |
			| '1'   | ''             | 'Dress'                | 'XS/Blue'    | ''                    | 'pcs'    | '6,000'        | '6,000'         | ''                     | ''               |
			| '2'   | ''             | 'Product 1 with SLN'   | 'ODS'        | ''                    | 'pcs'    | '2,000'        | '2,000'         | ''                     | ''               |
			| '3'   | ''             | 'Product 1 with SLN'   | 'PZU'        | '8908899877'          | 'pcs'    | '1,000'        | '1,000'         | ''                     | ''               |
			| '4'   | ''             | 'Dress'                | 'S/Yellow'   | ''                    | 'pcs'    | '3,000'        | '3,000'         | ''                     | ''               |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Manual fixed count"
		And I set checkbox "Exp. count"
		And I click "Next" button	
		Then the form attribute named "Field_ExpCount" became equal to "Yes"
		Then the form attribute named "Field_PhysCount" became equal to "No"
		Then the form attribute named "Field_ManualFixedCount" became equal to "Yes"
		Then the form attribute named "Field_Difference" became equal to "No"
		Then the form attribute named "Field_Description" became equal to "No"
		And I close all client application windows	

Scenario: _020113 load data in the Bundling
		And I close all client application windows
	* Open Bundling
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'       |
		And I close all client application windows	


Scenario: _020113 load data in the GoodsReceipt
		And I close all client application windows
	* Open GoodsReceipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'   | 'Serial lot numbers'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'      | ''                      |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'      | ''                      |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'      | '8908899877'            |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'      | ''                      |
		And I close all client application windows		

Scenario: _020114 load data in the Internal supply request
		And I close all client application windows
	* Open InternalSupplyRequest
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'       |
		And I close all client application windows

Scenario: _020115 load data in the Inventory transfer
		And I close all client application windows
	* Open InventoryTransfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'   | 'Serial lot numbers'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'      | ''                      |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'      | ''                      |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'      | '8908899877'            |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'      | ''                      |
		And I close all client application windows	

Scenario: _020116 load data in the Inventory transfer order
		And I close all client application windows
	* Open InventoryTransferOrder
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'       |
		And I close all client application windows

Scenario: _020117 load data in the Item stock adjustment
		And I close all client application windows
	* Open ItemStockAdjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key (surplus)'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'              | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'                  | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'                  | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'             | 'pcs'    | '3,000'       |
		And I close all client application windows
		
Scenario: _020118 load data in the Physical count by location
		And I close all client application windows
	* Open PhysicalCountByLocation
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Phys. count'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'          |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'          |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'          |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'          |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Date"
		And I click "Next" button	
		Then the form attribute named "Field_Date" became equal to "Yes"
		Then the form attribute named "Field_PhysCount" became equal to "No"
		And I close all client application windows			

Scenario: _020119 load data in the Purchase invoice
		And I close all client application windows
	* Open PurchaseInvoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'   | 'Serial lot numbers'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'      | ''                      |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'      | ''                      |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'      | '8908899877'            |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'      | ''                      |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Price"
		And I set checkbox "Delivery date"
		And I set checkbox "Detail"
		And I click "Next" button
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then the form attribute named "Field_Price" became equal to "Yes"
		Then the form attribute named "Field_OffersAmount" became equal to "No"
		Then the form attribute named "Field_TaxAmount" became equal to "No"
		Then the form attribute named "Field_NetAmount" became equal to "No"
		Then the form attribute named "Field_TotalAmount" became equal to "No"
		Then the form attribute named "Field_DeliveryDate" became equal to "Yes"
		Then the form attribute named "Field_Detail" became equal to "Yes"
		And I close all client application windows

Scenario: _020120 load data in the Purchase order
		And I close all client application windows
	* Open Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'       |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Price"
		And I set checkbox "Delivery date"
		And I set checkbox "Detail"
		And I click "Next" button
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then the form attribute named "Field_Price" became equal to "Yes"
		Then the form attribute named "Field_OffersAmount" became equal to "No"
		Then the form attribute named "Field_TaxAmount" became equal to "No"
		Then the form attribute named "Field_NetAmount" became equal to "No"
		Then the form attribute named "Field_TotalAmount" became equal to "No"
		Then the form attribute named "Field_DeliveryDate" became equal to "Yes"
		Then the form attribute named "Field_Detail" became equal to "Yes"
		And I close all client application windows
						

Scenario: _020122 load data in the Purchase return
		And I close all client application windows
	* Open Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'   | 'Serial lot numbers'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'      | ''                      |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'      | ''                      |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'      | '8908899877'            |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'      | ''                      |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Price"
		And I set checkbox "Detail"
		And I click "Next" button
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then the form attribute named "Field_Price" became equal to "Yes"
		Then the form attribute named "Field_OffersAmount" became equal to "No"
		Then the form attribute named "Field_TaxAmount" became equal to "No"
		Then the form attribute named "Field_NetAmount" became equal to "No"
		Then the form attribute named "Field_TotalAmount" became equal to "No"
		Then the form attribute named "Field_Detail" became equal to "Yes"
		And I close all client application windows

Scenario: _020123 load data in the Purchase return order
		And I close all client application windows
	* Open Purchase return order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'       |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Price"
		And I click "Next" button
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then the form attribute named "Field_Price" became equal to "Yes"
		Then the form attribute named "Field_OffersAmount" became equal to "No"
		Then the form attribute named "Field_TaxAmount" became equal to "No"
		Then the form attribute named "Field_NetAmount" became equal to "No"
		Then the form attribute named "Field_TotalAmount" became equal to "No"
		And I close all client application windows

Scenario: _020124 load data in the Retail return receipt
		And I close all client application windows
	* Open Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'   | 'Serial lot numbers'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'      | ''                      |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'      | ''                      |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'      | '8908899877'            |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'      | ''                      |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Total amount"
		And I set checkbox "Detail"
		And I click "Next" button
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then the form attribute named "Field_Price" became equal to "No"
		Then the form attribute named "Field_OffersAmount" became equal to "No"
		Then the form attribute named "Field_TaxAmount" became equal to "No"
		Then the form attribute named "Field_NetAmount" became equal to "No"
		Then the form attribute named "Field_TotalAmount" became equal to "Yes"
		Then the form attribute named "Field_Detail" became equal to "Yes"
		And I close all client application windows
		
Scenario: _020125 load data in the Retail sales receipt
		And I close all client application windows
	* Open Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'   | 'Serial lot numbers'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'      | ''                      |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'      | ''                      |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'      | '8908899877'            |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'      | ''                      |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Price"
		And I set checkbox "Detail"
		And I click "Next" button
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then the form attribute named "Field_Price" became equal to "Yes"
		Then the form attribute named "Field_OffersAmount" became equal to "No"
		Then the form attribute named "Field_TaxAmount" became equal to "No"
		Then the form attribute named "Field_NetAmount" became equal to "No"
		Then the form attribute named "Field_TotalAmount" became equal to "No"
		Then the form attribute named "Field_Detail" became equal to "Yes"
		And I close all client application windows	

Scenario: _020126 load data in the Sales order
		And I close all client application windows
	* Open Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'       |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Price"
		And I set checkbox "Detail"
		And I set checkbox "Total amount"
		And I click "Next" button
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then the form attribute named "Field_Price" became equal to "Yes"
		Then the form attribute named "Field_OffersAmount" became equal to "No"
		Then the form attribute named "Field_TaxAmount" became equal to "No"
		Then the form attribute named "Field_NetAmount" became equal to "No"
		Then the form attribute named "Field_TotalAmount" became equal to "Yes"
		Then the form attribute named "Field_DeliveryDate" became equal to "No"
		Then the form attribute named "Field_Detail" became equal to "Yes"
		And I close all client application windows		
	

Scenario: _020128 load data in the Sales report from trade agent
		And I close all client application windows
	* Open Sales report from trade agent
		Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'   | 'Serial lot numbers'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'      | ''                      |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'      | ''                      |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'      | '8908899877'            |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'      | ''                      |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Consignor price"
		And I set checkbox "Price"
		Then the form attribute named "Field_ConsignorPrice" became equal to "Yes"
		Then the form attribute named "Field_TradeAgentFeePercent" became equal to "No"
		Then the form attribute named "Field_TradeAgentFeeAmount" became equal to "No"
		Then the form attribute named "Field_Price" became equal to "Yes"
		Then the form attribute named "Field_TaxAmount" became equal to "No"
		Then the form attribute named "Field_NetAmount" became equal to "No"
		Then the form attribute named "Field_TotalAmount" became equal to "No"
		Then the form attribute named "Field_Detail" became equal to "No"	
		And I click "Next" button
		And I close all client application windows	

Scenario: _020129 load data in the Sales report to consignor
		And I close all client application windows
	* Open Sales report to consignor
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'   | 'Serial lot numbers'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'      | ''                      |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'      | ''                      |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'      | '8908899877'            |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'      | ''                      |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Consignor price"
		And I set checkbox "Price"
		And I set checkbox "Total amount"
		Then the form attribute named "ShowImage" became equal to "No"
		Then the form attribute named "Field_ConsignorPrice" became equal to "Yes"
		Then the form attribute named "Field_TradeAgentFeePercent" became equal to "No"
		Then the form attribute named "Field_TradeAgentFeeAmount" became equal to "No"
		Then the form attribute named "Field_Price" became equal to "Yes"
		Then the form attribute named "Field_TaxAmount" became equal to "No"
		Then the form attribute named "Field_NetAmount" became equal to "No"
		Then the form attribute named "Field_TotalAmount" became equal to "Yes"			
		And I close all client application windows	

Scenario: _020130 load data in the Sales return
		And I close all client application windows
	* Open Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'   | 'Serial lot numbers'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'      | ''                      |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'      | ''                      |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'      | '8908899877'            |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'      | ''                      |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Price"
		And I click "Next" button
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then the form attribute named "Field_Price" became equal to "Yes"
		Then the form attribute named "Field_OffersAmount" became equal to "No"
		Then the form attribute named "Field_TaxAmount" became equal to "No"
		Then the form attribute named "Field_NetAmount" became equal to "No"
		Then the form attribute named "Field_TotalAmount" became equal to "No"
		And I close all client application windows
	
Scenario: _020132 load data in the Sales return order
		And I close all client application windows
	* Open Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'       |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Price"
		And I click "Next" button
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then the form attribute named "Field_Price" became equal to "Yes"
		Then the form attribute named "Field_OffersAmount" became equal to "No"
		Then the form attribute named "Field_TaxAmount" became equal to "No"
		Then the form attribute named "Field_NetAmount" became equal to "No"
		Then the form attribute named "Field_TotalAmount" became equal to "No"
		And I close all client application windows

Scenario: _020133 load data in the Shipment confirmation
		And I close all client application windows
	* Open Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'       |
		And I close all client application windows

Scenario: _020134 load data in the Stock adjustment as surplus
		And I close all client application windows
	* Open Stock adjustment as surplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'       |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Price"
		And I click "Next" button
		Then the form attribute named "Field_Price" became equal to "Yes"
		Then the form attribute named "Field_Amount" became equal to "No"
		Then the form attribute named "Field_AmountTax" became equal to "No"		
		And I close all client application windows

Scenario: _020135 load data in the Stock adjustment as write off
		And I close all client application windows
	* Open Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'       |
		And I close all client application windows

Scenario: _020136 load data in the Unbundling
		And I close all client application windows
	* Open Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'       |
		And I close all client application windows


Scenario: _020137 load data in the Work order
		And I close all client application windows
	* Open Work order
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'       |
	* Check additional fields for load data
		And in the table "ItemList" I click "Load data from table" button
		And I move to "Additional fields" tab
		And I set checkbox "Price"
		And I click "Next" button
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then the form attribute named "Field_Price" became equal to "Yes"
		Then the form attribute named "Field_OffersAmount" became equal to "No"
		Then the form attribute named "Field_TaxAmount" became equal to "No"
		Then the form attribute named "Field_NetAmount" became equal to "No"
		Then the form attribute named "Field_TotalAmount" became equal to "No"
		And I close all client application windows

Scenario: _020138 load data in the Work sheet
		And I close all client application windows
	* Open Work sheet
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '6,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'    | '1,000'       |
			| 'Dress'                | 'S/Yellow'   | 'pcs'    | '3,000'       |
		And I close all client application windows
				

Scenario: _020139 load data in the SI (each sln new row, load by sln)
		And I close all client application windows
	* Open Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Check load data form
		And in the table "ItemList" I click "Load data from table" button
		And I change "Load type" radio button value to "Serial lot number"		
	* Add barcodes
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009098"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009099"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And in "Template" spreadsheet document I move to "R5C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009100"
		And in "Template" spreadsheet document I move to "R5C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And I click "Next" button
		And I click "Next" button
	* Check document
		And "ItemList" table became equal
			| 'Inventory origin'   | 'Item'                           | 'Item key'   | 'Unit'   | 'Serial lot numbers'   | 'Quantity'    |
			| 'Own stocks'         | 'Product 7 with SLN (new row)'   | 'PZU'        | 'pcs'    | '9009098'              | '2,000'       |
			| 'Own stocks'         | 'Product 7 with SLN (new row)'   | 'PZU'        | 'pcs'    | '9009099'              | '1,000'       |
			| 'Own stocks'         | 'Product 7 with SLN (new row)'   | 'ODS'        | 'pcs'    | '9009100'              | '1,000'       |
		And I close all client application windows
		
				

Scenario: _020140 load data in the SI (each sln new row, load by barcode)
		And I close all client application windows
	* Open Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Check load data form
		And in the table "ItemList" I click "Load data from table" button	
	* Add barcodes
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009098"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009099"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And in "Template" spreadsheet document I move to "R5C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009100"
		And in "Template" spreadsheet document I move to "R5C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And I click "Next" button
		And I click "Next" button
	* Check document
		And "ItemList" table became equal
			| 'Inventory origin'   | 'Item'                           | 'Item key'   | 'Unit'   | 'Serial lot numbers'   | 'Quantity'    |
			| 'Own stocks'         | 'Product 7 with SLN (new row)'   | 'PZU'        | 'pcs'    | '9009098'              | '2,000'       |
			| 'Own stocks'         | 'Product 7 with SLN (new row)'   | 'PZU'        | 'pcs'    | '9009099'              | '1,000'       |
			| 'Own stocks'         | 'Product 7 with SLN (new row)'   | 'ODS'        | 'pcs'    | '9009100'              | '1,000'       |
		And I close all client application windows	
				
		

Scenario: _020141 load data in the SO (each sln new row, load by barcode)
		And I close all client application windows
	* Open Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Check load data form
		And in the table "ItemList" I click "Load data from table" button	
	* Add barcodes
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009098"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009099"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And in "Template" spreadsheet document I move to "R5C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009100"
		And in "Template" spreadsheet document I move to "R5C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And I click "Next" button
		And I click "Next" button
	* Check document
		And "ItemList" table became equal
			| 'Procurement method'   | 'Item key'   | 'Quantity'   | 'Unit'   | 'Item'                            |
			| 'Stock'                | 'PZU'        | '3,000'      | 'pcs'    | 'Product 7 with SLN (new row)'    |
			| 'Stock'                | 'ODS'        | '1,000'      | 'pcs'    | 'Product 7 with SLN (new row)'    |
		And I close all client application windows
		
		

Scenario: _020142 load data in the PhysicalInventory (each sln new row, use serial lot)
		And I close all client application windows
	* Open Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
		And I set checkbox "Use serial lot"
	* Check load data form
		And in the table "ItemList" I click "Load data from table" button	
	* Add barcodes
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009098"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009099"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And in "Template" spreadsheet document I move to "R5C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009100"
		And in "Template" spreadsheet document I move to "R5C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And I click "Next" button
		And I click "Next" button
	* Check document
		And "ItemList" table became equal
			| 'Item'                           | 'Item key'   | 'Unit'   | 'Serial lot number'   | 'Phys. count'    |
			| 'Product 7 with SLN (new row)'   | 'PZU'        | 'pcs'    | '9009098'             | '2,000'          |
			| 'Product 7 with SLN (new row)'   | 'PZU'        | 'pcs'    | '9009099'             | '1,000'          |
			| 'Product 7 with SLN (new row)'   | 'ODS'        | 'pcs'    | '9009100'             | '1,000'          |
		And I close all client application windows	


Scenario: _020143 load data in the PhysicalInventory (each sln new row, not use serial lot)
		And I close all client application windows
	* Open Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
	* Check load data form
		And in the table "ItemList" I click "Load data from table" button	
	* Add barcodes
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009098"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009099"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And in "Template" spreadsheet document I move to "R5C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009100"
		And in "Template" spreadsheet document I move to "R5C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And I click "Next" button
		And I click "Next" button
	* Check document
		And "ItemList" table became equal
			| 'Item'                           | 'Item key'   | 'Unit'   | 'Serial lot number'   | 'Phys. count'    |
			| 'Product 7 with SLN (new row)'   | 'PZU'        | 'pcs'    | ''                    | '3,000'          |
			| 'Product 7 with SLN (new row)'   | 'ODS'        | 'pcs'    | ''                    | '1,000'          |
		And I close all client application windows				
								
		

Scenario: _020144 load data in the PhysicalCountByLocation (each sln new row, use serial lot)
		And I close all client application windows
	* Open PhysicalCountByLocation
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I click the button named "FormCreate"
		And I set checkbox "Use serial lot"
	* Check load data form
		And in the table "ItemList" I click "Load data from table" button	
	* Add barcodes
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009098"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009099"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And in "Template" spreadsheet document I move to "R5C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009100"
		And in "Template" spreadsheet document I move to "R5C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And I click "Next" button
		And I click "Next" button
	* Check document
		And "ItemList" table became equal
			| 'Item'                           | 'Item key'   | 'Unit'   | 'Serial lot number'   | 'Phys. count'    |
			| 'Product 7 with SLN (new row)'   | 'PZU'        | 'pcs'    | '9009098'             | '2,000'          |
			| 'Product 7 with SLN (new row)'   | 'PZU'        | 'pcs'    | '9009099'             | '1,000'          |
			| 'Product 7 with SLN (new row)'   | 'ODS'        | 'pcs'    | '9009100'             | '1,000'          |
		And I close all client application windows	


Scenario: _020145 load data in the PhysicalCountByLocation (each sln new row, not use serial lot)
		And I close all client application windows
	* Open PhysicalCountByLocation
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I click the button named "FormCreate"
	* Check load data form
		And in the table "ItemList" I click "Load data from table" button	
	* Add barcodes
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009098"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009099"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And in "Template" spreadsheet document I move to "R5C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009100"
		And in "Template" spreadsheet document I move to "R5C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "1"
		And I click "Next" button
		And I click "Next" button
	* Check document
		And "ItemList" table became equal
			| 'Item'                           | 'Item key'   | 'Unit'   | 'Serial lot number'   | 'Phys. count'    |
			| 'Product 7 with SLN (new row)'   | 'PZU'        | 'pcs'    | ''                    | '3,000'          |
			| 'Product 7 with SLN (new row)'   | 'ODS'        | 'pcs'    | ''                    | '1,000'          |
		And I close all client application windows						
				
		
				
Scenario: _020146 load data in the Price list (by items)
		And I close all client application windows
	* Open PriceList
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
	* Check load data form
		And in the table "ItemList" I click "Load data from table" button					
	* Add barcodes
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009098"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "67789997777801"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "10"
		And I click "Next" button
		And I click "Next" button
	* Check
		And "ItemList" table became equal
			| '#' | 'Item'                         | 'Unit' | 'Input unit' | 'Input price' | 'Price' |
			| '1' | 'Product 7 with SLN (new row)' | 'pcs'  | 'pcs'        | ''            | '2,00'  |
			| '2' | 'Product 1 with SLN'           | 'pcs'  | 'pcs'        | ''            | '10,00' |
		And I select all lines of "ItemList" table
		And in the table "ItemList" I click "Delete" button
	* Load by serial lot number
		And in the table "ItemList" I click "Load data from table" button
		And I change "Load type" radio button value to "Serial lot number"
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "8908899877"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "4"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "09987897977894"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "11"
		And I click "Next" button
		And I click "Next" button
	* Check
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Unit' | 'Input unit' | 'Input price' | 'Price' |
			| '1' | 'Product 1 with SLN' | 'pcs'  | 'pcs'        | ''            | '4,00'  |
			| '2' | 'Product 3 with SLN' | 'pcs'  | 'pcs'        | ''            | '11,00' |	
		And I select all lines of "ItemList" table
		And in the table "ItemList" I click "Delete" button
	* Load by item/item key			
		And in the table "ItemList" I click "Load data from table" button
		And I change "Load type" radio button value to "Item / Item key"
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "Product 1 with SLN"
		And in "Template" spreadsheet document I move to "R3C3" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "5"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "Product 2 with SLN"
		And in "Template" spreadsheet document I move to "R4C3" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "12"
		And I click "Next" button
		And I click "Next" button
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Unit' | 'Input unit' | 'Input price' | 'Price' |
			| '1' | 'Product 1 with SLN' | 'pcs'  | 'pcs'        | ''            | '5,00'  |
			| '2' | 'Product 2 with SLN' | 'pcs'  | 'pcs'        | ''            | '12,00' |
		And I click Select button of "Price type" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Basic Price Types' |
		And I select current line in "List" table
		And I click "Post" button
		And I save the value of "Number" field as "NumberPL020146"
		And I click "Post and close" button
		And "List" table contains lines
			| 'Number'             |
			| '$NumberPL020146$' |
		
							

Scenario: _020147 load data in the Price list (by item key)
		And I close all client application windows
	* Open PriceList
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
		And I change "Set price" radio button value to "By item keys"		
	* Check load data form
		And in the table "ItemKeyList" I click "Load data from table" button							
	* Add barcodes
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "9009098"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "67789997777801"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "10"
		And I click "Next" button
		And I click "Next" button
	* Check
		And "ItemKeyList" table became equal
			| '#' | 'Item'                         | 'Item key' | 'Unit' | 'Input unit' | 'Input price' | 'Price' |
			| '1' | 'Product 7 with SLN (new row)' | 'PZU'      | 'pcs'  | 'pcs'        | ''            | '2,00'  |
			| '2' | 'Product 1 with SLN'           | 'ODS'      | 'pcs'  | 'pcs'        | ''            | '10,00' |	
		And I select all lines of "ItemKeyList" table
		And in the table "ItemKeyList" I click "Delete" button
	* Load by serial lot number
		And in the table "ItemKeyList" I click "Load data from table" button
		And I change "Load type" radio button value to "Serial lot number"
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "8908899877"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "4"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "09987897977894"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "11"
		And I click "Next" button
		And I click "Next" button
	* Check
		And "ItemKeyList" table became equal
			| '#' | 'Item'               | 'Unit' | 'Input unit' | 'Input price' | 'Price' |
			| '1' | 'Product 1 with SLN' | 'pcs'  | 'pcs'        | ''            | '4,00'  |
			| '2' | 'Product 3 with SLN' | 'pcs'  | 'pcs'        | ''            | '11,00' |	
		And I select all lines of "ItemKeyList" table
		And in the table "ItemKeyList" I click "Delete" button
	* Load by item/item key			
		And in the table "ItemKeyList" I click "Load data from table" button
		And I change "Load type" radio button value to "Item / Item key"
		And in "Template" spreadsheet document I move to "R3C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "35"
		And in "Template" spreadsheet document I move to "R3C3" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "30"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "38"
		And in "Template" spreadsheet document I move to "R4C3" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "31"
		And I click "Next" button
		And I click "Next" button
		And I click Select button of "Price type" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Basic Price Types' |
		And I select current line in "List" table
		And I click "Post" button
		And I save the value of "Number" field as "NumberPL020147"
		And I click "Post and close" button
		And "List" table contains lines
			| 'Number'           |
			| '$NumberPL020147$' |				

		
				
				
