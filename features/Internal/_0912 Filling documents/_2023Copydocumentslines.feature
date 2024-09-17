#language: en
@tree
@Positive
@FillingDocuments

Feature: check copy lines from documents

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _0155100 preparation ( filling documents)
	When set True value to the constant
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
		When Create catalog Countries objects
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create catalog Taxes objects (for work order)
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When Create catalog PlanningPeriods objects
		When create items for work order
		When Create catalog BillOfMaterials objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects
		When Create catalog PartnerItems objects
		When Create information register Taxes records (VAT)
		When Create catalog CancelReturnReasons objects
		When Create document SalesInvoice objects (for copy lines)
		When Create document PhysicalInventory objects (for copy lines)


Scenario: _0154192 copy lines from SI to IT
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open IT and check copy lines
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| '#'   | 'Item'                 | 'Item key'   | 'Serial lot numbers'   | 'Unit'                | 'Source of origins'   | 'Quantity'   | 'Inventory transfer order'   | 'Production planning'    |
			| '1'   | 'Product 1 with SLN'   | 'PZU'        | '0512; 0514'           | 'pcs'                 | ''                    | '3,000'      | ''                           | ''                       |
			| '2'   | 'Dress'                | 'XS/Blue'    | ''                     | 'box Dress (8 pcs)'   | ''                    | '2,000'      | ''                           | ''                       |
			| '3'   | 'Product 3 with SLN'   | 'UNIQ'       | '0514'                 | 'pcs'                 | ''                    | '2,000'      | ''                           | ''                       |
			| '4'   | 'Product 3 with SLN'   | 'PZU'        | ''                     | 'pcs'                 | ''                    | '8,000'      | ''                           | ''                       |
		And I close all client application windows

Scenario: _0154193 copy lines from SI to ISR
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open ISR and check copy lines
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | 'pcs'                 | '8,000'       |
		And I close all client application windows	

Scenario: _0154194 copy lines from SI to ITO
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open ITO and check copy lines
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | 'pcs'                 | '8,000'       |
		And I close all client application windows					

Scenario: _0154194 copy lines from SI to ItemStockAdjustment
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open ItemStockAdjustment and check copy lines
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| '#'   | 'Item'                 | 'Unit'                | 'Quantity'   | 'Item key (write off)'   | 'Item key (surplus)'   | 'Serial lot number (surplus)'   | 'Serial lot number (write off)'    |
			| '1'   | 'Product 1 with SLN'   | 'pcs'                 | '2,000'      | ''                       | 'PZU'                  | '0512'                          | ''                                 |
			| '2'   | 'Product 1 with SLN'   | 'pcs'                 | '1,000'      | ''                       | 'PZU'                  | '0514'                          | ''                                 |
			| '3'   | 'Dress'                | 'box Dress (8 pcs)'   | '2,000'      | ''                       | 'XS/Blue'              | ''                              | ''                                 |
			| '4'   | 'Product 3 with SLN'   | 'pcs'                 | '2,000'      | ''                       | 'UNIQ'                 | '0514'                          | ''                                 |
			| '5'   | 'Product 3 with SLN'   | 'pcs'                 | '8,000'      | ''                       | 'PZU'                  | ''                              | ''                                 |
		And I close all client application windows

Scenario: _0154195 copy lines from SI to PlannedReceiptReservation
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open PlannedReceiptReservation and check copy lines
		Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _0154196 copy lines from SI to PurchaseInvoice
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open PurchaseInvoice and check copy lines
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Serial lot numbers'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | '0512; 0514'           | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | ''                     | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | '0514'                 | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | ''                     | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _0154197 copy lines from SI to PurchaseOrder
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open PurchaseOrder and check copy lines
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _0154198 copy lines from SI to PurchaseReturn
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open PurchaseReturn and check copy lines
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Serial lot numbers'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | '0512; 0514'           | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | ''                     | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | '0514'                 | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | ''                     | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _0154199 copy lines from SI to PurchaseReturnOrder
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open PurchaseReturnOrder and check copy lines
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _01541991 copy lines from SI to RetailSalesReceipt
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open RetailSalesReceipt and check copy lines
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Serial lot numbers'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | '0512; 0514'           | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | ''                     | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | '0514'                 | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | ''                     | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _01541992 copy lines from SI to SalesOrder
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open SalesOrder and check copy lines
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | 'pcs'                 | '8,000'       |
	* Copy from SO to new SI
		Then I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And in the table "ItemList" I click "Paste from clipboard" button	
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | 'pcs'                 | '8,000'       |
		And I close all client application windows


Scenario: _01541993 copy lines from SI to SalesReportFromTradeAgent
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open SalesReportFromTradeAgent and check copy lines
		Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Serial lot numbers'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | '0512; 0514'           | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | ''                     | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | '0514'                 | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | ''                     | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _01541994 copy lines from SI to SalesReportToConsignor
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open SalesReportToConsignor and check copy lines
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Serial lot numbers'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | '0512; 0514'           | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | ''                     | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | '0514'                 | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | ''                     | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _01541995 copy lines from SI to SalesReportToConsignor
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open SalesReportToConsignor and check copy lines
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Serial lot numbers'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | '0512; 0514'           | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | ''                     | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | '0514'                 | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | ''                     | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _01541996 copy lines from SI to SalesReportToConsignor
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open SalesReportToConsignor and check copy lines
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Serial lot numbers'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | '0512; 0514'           | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | ''                     | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | '0514'                 | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | ''                     | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _01541997 copy lines from SI to SalesReturn
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open SalesReturn and check copy lines
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Serial lot numbers'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | '0512; 0514'           | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | ''                     | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | '0514'                 | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | ''                     | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _01541998 copy lines from SI to SalesReturnOrder
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open SalesReturnOrder and check copy lines
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _01541999 copy lines from SI to ShipmentConfirmation
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open ShipmentConfirmation and check copy lines
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _01541981 copy lines from SI to StockAdjustmentAsSurplus
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open StockAdjustmentAsSurplus and check copy lines
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Serial lot numbers'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | '0512; 0514'           | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | ''                     | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | '0514'                 | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | ''                     | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _01541981 copy lines from SI to StockAdjustmentAsWriteOff
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open StockAdjustmentAsWriteOff and check copy lines
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Serial lot numbers'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | '0512; 0514'           | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | ''                     | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | '0514'                 | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | ''                     | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _01541982 copy lines from SI to Unbundling
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open Unbundling and check copy lines
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _01541982 copy lines from SI to Bundling
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open Bundling and check copy lines
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Product 1 with SLN'   | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'                | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | 'pcs'                 | '2,000'       |
			| 'Product 3 with SLN'   | 'PZU'        | 'pcs'                 | '8,000'       |
		And I close all client application windows

Scenario: _01541983 copy lines from Physical inventory to Sales invoice
	And I close all client application windows
	* Select Physical inventory and copy lines
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'    |
			| '1 024'     |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'ODS'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
		And I change "Copy quantity as" radio button value to "Phys. count"
		And I click "OK" button	
	* Open Sales invoice and check copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Serial lot numbers'   | 'Quantity'    |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '0512'                 | '3,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '0514'                 | '2,000'       |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | ''                     | '3,000'       |
			| 'Product 4 with SLN'   | 'UNIQ'       | 'pcs'    | ''                     | '4,000'       |
		And I close all client application windows

Scenario: _01541984 copy lines from Physical inventory to Sales order
	And I close all client application windows
	* Select Physical inventory and copy lines
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'    |
			| '1 024'     |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'ODS'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
		And I change "Copy quantity as" radio button value to "Phys. count"
		And I click "OK" button	
	* Open Sales order and check copy lines
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '3,000'       |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'       |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '3,000'       |
			| 'Product 4 with SLN'   | 'UNIQ'       | 'pcs'    | '4,000'       |
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Paste to Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And I change "Paste quantity as" radio button value to "Phys. count"
		And I click "OK" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Unit'   | 'Phys. count'    |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '3,000'          |
			| 'Product 1 with SLN'   | 'ODS'        | 'pcs'    | '2,000'          |
			| 'Dress'                | 'XS/Blue'    | 'pcs'    | '3,000'          |
			| 'Product 4 with SLN'   | 'UNIQ'       | 'pcs'    | '4,000'          |
		And I close all client application windows

Scenario: _01541985 copy lines from Physical inventory to Physical count by location
	And I close all client application windows
	* Select Physical inventory and copy lines
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'    |
			| '1 024'     |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'ODS'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
		And I change "Copy quantity as" radio button value to "Phys. count"
		And I click "OK" button	
	* Open PhysicalCountByLocation and check copy lines
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I click the button named "FormCreate"
		And I set checkbox "Use serial lot"
		And I click "Paste from clipboard" button
		And I change "Paste quantity as" radio button value to "Phys. count"
		And I click "OK" button
		And "ItemList" table became equal
			| 'Item'                 | 'Item key'   | 'Serial lot number'   | 'Unit'   | 'Phys. count'    |
			| 'Product 1 with SLN'   | 'ODS'        | '0512'                | 'pcs'    | '3,000'          |
			| 'Product 1 with SLN'   | 'ODS'        | '0514'                | 'pcs'    | '2,000'          |
			| 'Dress'                | 'XS/Blue'    | ''                    | 'pcs'    | '3,000'          |
			| 'Product 4 with SLN'   | 'UNIQ'       | ''                    | 'pcs'    | '4,000'          |
		And I close all client application windows

Scenario: _01541986 copy lines from SI to Physical inventory
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open Physical inventory and check copy lines
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
		And I set checkbox "Use serial lot"
		And I click "Paste from clipboard" button
		And I change "Paste quantity as" radio button value to "Phys. count"
		And I click "OK" button
		And "ItemList" table became equal
			| '#'   | 'Exp. count'   | 'Item'                 | 'Item key'   | 'Serial lot number'   | 'Unit'                | 'Difference'   | 'Phys. count'   | 'Manual fixed count'   | 'Comment'        |
			| '1'   | ''             | 'Product 1 with SLN'   | 'PZU'        | '0512'                | 'pcs'                 | '2,000'        | '2,000'         | ''                     | ''               |
			| '2'   | ''             | 'Product 1 with SLN'   | 'PZU'        | '0514'                | 'pcs'                 | '1,000'        | '1,000'         | ''                     | ''               |
			| '3'   | ''             | 'Dress'                | 'XS/Blue'    | ''                    | 'box Dress (8 pcs)'   | '2,000'        | '2,000'         | ''                     | ''               |
			| '4'   | ''             | 'Product 3 with SLN'   | 'UNIQ'       | '0514'                | 'pcs'                 | '2,000'        | '2,000'         | ''                     | ''               |
			| '5'   | ''             | 'Product 3 with SLN'   | 'PZU'        | ''                    | 'pcs'                 | '8,000'        | '8,000'         | ''                     | ''               |
		And I close all client application windows

Scenario: _01541987 copy lines from SI to GR
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open GR and check copy lines
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| '#'   | 'Item'                 | 'Item key'   | 'Serial lot numbers'   | 'Unit'                | 'Quantity'    |
			| '1'   | 'Product 1 with SLN'   | 'PZU'        | '0512; 0514'           | 'pcs'                 | '3,000'       |
			| '2'   | 'Dress'                | 'XS/Blue'    | ''                     | 'box Dress (8 pcs)'   | '2,000'       |
			| '3'   | 'Product 3 with SLN'   | 'UNIQ'       | '0514'                 | 'pcs'                 | '2,000'       |
			| '4'   | 'Product 3 with SLN'   | 'PZU'        | ''                     | 'pcs'                 | '8,000'       |
		And I close all client application windows


Scenario: _01541988 copy lines from SI to RetailReturnReceipt
	And I close all client application windows
	* Select SI and copy lines
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 290'     |
		And I select current line in "List" table
		And I click "Copy to clipboard" button
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		Then I select all lines of "ItemList" table
		And I click "Copy to clipboard" button
	* Open RetailReturnReceipt and check copy lines
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| '#'   | 'Item'                 | 'Item key'   | 'Serial lot numbers'   | 'Unit'                | 'Quantity'    |
			| '1'   | 'Product 1 with SLN'   | 'PZU'        | '0512; 0514'           | 'pcs'                 | '3,000'       |
			| '2'   | 'Dress'                | 'XS/Blue'    | ''                     | 'box Dress (8 pcs)'   | '2,000'       |
			| '3'   | 'Product 3 with SLN'   | 'UNIQ'       | '0514'                 | 'pcs'                 | '2,000'       |
			| '4'   | 'Product 3 with SLN'   | 'PZU'        | ''                     | 'pcs'                 | '8,000'       |
		And I close all client application windows


Scenario: _01541961 check copy lines from RetailSalesReceipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows
		
Scenario: _01541962 check copy lines from PurchaseReturn
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541963 check copy lines from GoodsReceipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541963 check copy lines from RetailReturnReceipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows
						

Scenario: _01541965 check copy lines from PurchaseOrder
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541966 check copy lines from SalesReturnOrder
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541967 check copy lines from ShipmentConfirmation
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541968 check copy lines from InternalSupplyRequest
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541969 check copy lines from PurchaseInvoice
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541970 check copy lines from StockAdjustmentAsWriteOff
	And Delay 10
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541971 check copy lines from Inventory transfer
	And Delay 80
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541972 check copy lines from Stock adjustment as surplus
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541973 check copy lines from Sales return
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541974 check copy lines from Purchase return order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541975 check copy lines from Bundling
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Bundling"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541976 check copy lines from Inventory transfer order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541977 check copy lines from Unbundling
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541978 check copy lines from Item stock adjustment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key (surplus)'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'                  | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'              | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key (surplus)'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'                  | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'              | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows


Scenario: _01541950 check copy lines from Planned receipt reservation
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541951 check copy lines from Sales report to consignor
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541952 check copy lines from Sales report from trade agent
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
	And I click the button named "FormCreate"
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Quantity'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'       |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'       |
		And I close all client application windows

Scenario: _01541953 check copy lines from Physical count by location (transaction type Physical inventory) 
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
	And I click the button named "FormCreate"
	And I select "Physical inventory" exact value from "Transaction type" drop-down list
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Phys. count'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'          |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'          |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
		And I change "Copy quantity as" radio button value to "Phys. count"
		And I click "OK" button	
		And I delete all lines of "ItemList" table
	* Past lines
		And I click "Paste from clipboard" button
		And I change "Paste quantity as" radio button value to "Phys. count"
		And I click "OK" button	
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Unit'                | 'Phys. count'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'          |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'          |
		And I close all client application windows

Scenario: _01541954 check copy lines from Physical count by location (transaction type Package) 
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
	And I click the button named "FormCreate"
	And I select "Package" exact value from "Transaction type" drop-down list
	* Add items
		And I fill "ItemList" table with data
			| 'Item'    | 'Item key'   | 'Unit'                | 'Phys. count'    |
			| 'Bag'     | 'PZU'        | 'pcs'                 | '3,000'          |
			| 'Dress'   | 'XS/Blue'    | 'box Dress (8 pcs)'   | '2,000'          |
	* Copy lines
		And I go to the first line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Copy to clipboard" button
	* Past lines
		Given I open hyperlink "e1cib/app/DataProcessor.PrintLabels"		
		And I click "Paste from clipboard" button
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Unit'              | 'Quantity' |
			| 'Bag'   | 'PZU'      | 'pcs'               | '3'        |
			| 'Dress' | 'XS/Blue'  | 'box Dress (8 pcs)' | '2'        |
		And I close all client application windows
