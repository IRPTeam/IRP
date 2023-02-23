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
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BusinessUnits objects
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
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
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| '#' | 'Price type'        | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'           | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Is additional item revenue' | 'Additional analytic' | 'Store'    | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order' | 'Revenue type' | 'Sales person' |
			| '1' | 'Basic Price Types' | 'Dress'              | 'XS/Blue'  | ''                   | 'No'                 | '475,93'     | 'pcs'  | ''                             | '6,000'    | '520,00' | '18%' | ''              | '2 644,07'   | '3 120,00'     | 'No'                         | ''                    | 'Store 01' | ''              | 'No'                        | ''       | ''            | ''             | ''             |
			| '2' | 'Basic Price Types' | 'Product 1 with SLN' | 'ODS'      | ''                   | 'No'                 | ''           | 'pcs'  | ''                             | '2,000'    | ''       | '18%' | ''              | ''           | ''             | 'No'                         | ''                    | 'Store 01' | ''              | 'No'                        | ''       | ''            | ''             | ''             |
			| '3' | 'Basic Price Types' | 'Product 1 with SLN' | 'PZU'      | ''                   | 'No'                 | ''           | 'pcs'  | '8908899877'                   | '1,000'    | ''       | '18%' | ''              | ''           | ''             | 'No'                         | ''                    | 'Store 01' | ''              | 'No'                        | ''       | ''            | ''             | ''             |
			| '4' | 'Basic Price Types' | 'Dress'              | 'S/Yellow' | ''                   | 'No'                 | '251,69'     | 'pcs'  | ''                             | '3,000'    | '550,00' | '18%' | ''              | '1 398,31'   | '1 650,00'     | 'No'                         | ''                    | 'Store 01' | ''              | 'No'                        | ''       | ''            | ''             | ''             |
		And I close all client application windows
		
		

Scenario: _020112 load data in the Physical inventory
		And I close all client application windows
	* Open Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
	* Filling Physical inventory
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'     |
		And I select current line in "List" table
		And I set checkbox "Use serial lot"	
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table became equal
			| '#' | 'Exp. count' | 'Item'               | 'Item key' | 'Serial lot number' | 'Unit' | 'Difference' | 'Phys. count' | 'Manual fixed count' | 'Description' |
			| '1' | ''           | 'Dress'              | 'XS/Blue'  | ''                  | 'pcs'  | '6,000'      | '6,000'       | ''                   | ''            |
			| '2' | ''           | 'Product 1 with SLN' | 'ODS'      | ''                  | 'pcs'  | '2,000'      | '2,000'       | ''                   | ''            |
			| '3' | ''           | 'Product 1 with SLN' | 'PZU'      | '8908899877'        | 'pcs'  | '1,000'      | '1,000'       | ''                   | ''            |
			| '4' | ''           | 'Dress'              | 'S/Yellow' | ''                  | 'pcs'  | '3,000'      | '3,000'       | ''                   | ''            |		
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' | 'Serial lot numbers'|
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    | ''                  |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    | ''                  |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    | '8908899877'        |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    | ''                  |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' | 'Serial lot numbers'|
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    | ''                  |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    | ''                  |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    | '8908899877'        |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    | ''                  |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
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
			| 'Item'               | 'Item key (surplus)' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'            | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'                | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'                | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow'           | 'pcs'  | '3,000'    |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Phys. count' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'       |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'       |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'       |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'       |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' | 'Serial lot numbers'|
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    | ''                  |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    | ''                  |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    | '8908899877'        |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    | ''                  |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
		And I close all client application windows
						
Scenario: _020121 load data in the Purchase order closing
		And I close all client application windows
	* Open Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' | 'Serial lot numbers'|
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    | ''                  |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    | ''                  |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    | '8908899877'        |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    | ''                  |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' | 'Serial lot numbers'|
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    | ''                  |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    | ''                  |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    | '8908899877'        |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    | ''                  |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' | 'Serial lot numbers'|
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    | ''                  |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    | ''                  |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    | '8908899877'        |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    | ''                  |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
		And I close all client application windows		

Scenario: _020127 load data in the Sales order closing
		And I close all client application windows
	* Open Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' | 'Serial lot numbers'|
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    | ''                  |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    | ''                  |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    | '8908899877'        |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    | ''                  |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' | 'Serial lot numbers'|
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    | ''                  |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    | ''                  |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    | '8908899877'        |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    | ''                  |
		And I close all client application windows	

Scenario: _020130 load data in the Sales return
		And I close all client application windows
	* Open Sales report to consignor
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"
	* Check load data form
		When check load data form in the document
	* Check document
		And "ItemList" table contains lines
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' | 'Serial lot numbers'|
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    | ''                  |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    | ''                  |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    | '8908899877'        |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    | ''                  |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
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
			| 'Item'               | 'Item key' | 'Unit' | 'Quantity' |
			| 'Dress'              | 'XS/Blue'  | 'pcs'  | '6,000'    |
			| 'Product 1 with SLN' | 'ODS'      | 'pcs'  | '2,000'    |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '1,000'    |
			| 'Dress'              | 'S/Yellow' | 'pcs'  | '3,000'    |
		And I close all client application windows
				
		
				
	
				
		
				
		
		
				
		
				
				
		