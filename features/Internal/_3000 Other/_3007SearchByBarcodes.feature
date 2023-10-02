﻿#language: en
@tree
@Positive
@Other


Feature: add items to documents by barcode

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _300700 preparation (add items to documents by barcode)
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
		When Create catalog Partners objects (trade agent and consignor)
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
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
		When Create information register Barcodes records
		When update ItemKeys
		When Create information register Taxes records (VAT)


Scenario: _3007001 check preparation
	When check preparation

Scenario: _300701 barcode check in Sales order + price and tax filling
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	When check the barcode search in the sales documents + price and tax filling in

Scenario: _300702 barcode check in Sales invoice + price and tax filling
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	When check the barcode search in the sales documents + price and tax filling in

Scenario: _300703 barcode check in Sales return + price and tax filling
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	When check the barcode search on the return documents

Scenario: _300704 barcode check in Sales return order + price and tax filling
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	When check the barcode search on the return documents

Scenario: _300705 barcode check in Purchase order
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	When check the barcode search in the purchase/purchase returns

Scenario: _300706 barcode check in Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'   |
		| 'Ferron BP'     |
	And I select current line in "List" table
	And I click "SearchByBarcode" button
	And I input "2202283713" text in the field named "Barcode"
	And I move to the next attribute
	* Check adding an items and filling in the price in the tabular part
		And I click "Show row key" button
		And in the table "ItemList" I click "Edit quantity in base unit" button	
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Stock quantity'    |
			| 'Dress'   | 'S/Yellow'   | '1,000'      | 'pcs'    | '1,000'             |
		And I click "SearchByBarcode" button
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Stock quantity'    |
			| 'Dress'   | 'S/Yellow'   | '2,000'      | 'pcs'    | '2,000'             |
	And I close all client application windows

Scenario: _300707 barcode check in Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	When check the barcode search in the purchase/purchase returns

Scenario: _300708 barcode check in Purchase return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	When check the barcode search in the purchase/purchase returns

Scenario: _300709 barcode check in Goods receipt
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	When check the barcode search in storage operations documents

Scenario: _300710 barcode check in Shipment confirmation
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	When check the barcode search in storage operations documents

Scenario: _300711 barcode check in Inventory transfer
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	When check the barcode search in storage operations documents

Scenario: _300712 barcode check in Inventory transfer order
	Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
	When check the barcode search in storage operations documents

Scenario: _300713 barcode check in Internal Supply Request
	Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
	When check the barcode search in storage operations documents

Scenario: _300714 barcode check in SalesReportFromTradeAgent + price and tax filling
	Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
	When check the barcode search in the sales report from trade agent + price and tax filling in

Scenario: _300714 barcode check in sales report to consignor + price and tax filling
	Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
	When check the barcode search in the sales report to consignor + price and tax filling in

Scenario: _300716 barcode check in Bundling
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Bundling"
	When check the barcode search in the product bundling documents

Scenario: _300717 barcode check in Unbundling
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	When check the barcode search in the product bundling documents

Scenario: _300718 barcode check in StockAdjustmentAsSurplus
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
	When check the barcode search in storage operations documents

Scenario: _300719 barcode check in StockAdjustmentAsWriteOff
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
	When check the barcode search in storage operations documents


Scenario: _300720 barcode check in PhysicalInventory
	Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
	When check the barcode search in the PhysicalInventory documents

Scenario: _300721 barcode check in PhysicalCountByLocation
	Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "SearchByBarcode"
	And I input "2202283713" text in the field named "Barcode"
	And I move to the next attribute
	And Delay 4
	And in the table "ItemList" I click the button named "SearchByBarcode"
	And I input "2202283713" text in the field named "Barcode"
	And I move to the next attribute
	And "ItemList" table became equal
		| '#'  | 'Item'   | 'Item key'  | 'Unit'  | 'Phys. count'  | 'Date'   |
		| '1'  | 'Dress'  | 'S/Yellow'  | 'pcs'   | '1,000'        | '*'      |
		| '2'  | 'Dress'  | 'S/Yellow'  | 'pcs'   | '1,000'        | '*'      |
	And I close all client application windows


Scenario: _300722 barcode check in Item stock adjustment
	Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
	When check the barcode search in the Item stock adjustment

Scenario: _300723 barcode check in Price list
	Given I open hyperlink "e1cib/list/Document.PriceList"
	And I click the button named "FormCreate"
	* By item key
		* Add first string
			And I change "Set price" radio button value to "By item keys"
			And I click the button named "SearchByBarcode"
			And I input "2202283713" text in the field named "Barcode"
			And I move to the next attribute
			And "ItemKeyList" table contains lines
				| 'Item'     | 'Item key'    | 'Price'    | 'Input unit'     |
				| 'Dress'    | 'S/Yellow'    | ''         | 'pcs'            |
		* Add second string
			And I click the button named "SearchByBarcode"
			And I input "978020137962" text in the field named "Barcode"
			And I move to the next attribute
			And "ItemKeyList" table contains lines
				| 'Item'     | 'Item key'    | 'Price'    | 'Input unit'     |
				| 'Dress'    | 'S/Yellow'    | ''         | 'pcs'            |
				| 'Boots'    | '37/18SD'     | ''         | 'pcs'            |
		* Check active string when scan the same item
			And I go to line in "ItemKeyList" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			And I click the button named "SearchByBarcode"
			And I input "2202283713" text in the field named "Barcode"
			And I move to the next attribute
			And the current line of "ItemKeyList" table is equal to
				| 'Item'     | 'Item key'    | 'Price'    | 'Input unit'     |
				| 'Dress'    | 'S/Yellow'    | ''         | 'pcs'            |
			And I close all client application windows
	* By item
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
		* Add first string
			And I change "Set price" radio button value to "By items"
			And I click the button named "SearchByBarcodeItem"			
			And I input "2202283713" text in the field named "Barcode"
			And I move to the next attribute
			And "ItemList" table contains lines
				| 'Item'     | 'Price'    | 'Input unit'     |
				| 'Dress'    | ''         | 'pcs'            |
		* Add second string
			And I click the button named "SearchByBarcodeItem"
			And I input "978020137962" text in the field named "Barcode"
			And I move to the next attribute
			And "ItemList" table contains lines
				| 'Item'     | 'Price'    | 'Input unit'     |
				| 'Dress'    | ''         | 'pcs'            |
				| 'Boots'    | ''         | 'pcs'            |
		* Check active string when scan the same item
			And I go to line in "ItemList" table
				| 'Item'      |
				| 'Boots'     |
			And I click the button named "SearchByBarcodeItem"	
			And I input "2202283713" text in the field named "Barcode"
			And I move to the next attribute
			And the current line of "ItemList" table is equal to
				| 'Item'     | 'Price'    | 'Input unit'     |
				| 'Dress'    | ''         | 'pcs'            |
		And I close all client application windows
		
Scenario: _300725 check function Always add new row after scan
	And I close all client application windows
	* Select item type
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Clothes'        |
		And I select current line in "List" table
		And I set checkbox "Always add new row after scan"
		And I click "Save and close" button
	* Check function Always add new row after scan
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		And I click "SearchByBarcode" button
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
		And I click "SearchByBarcode" button
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table became equal
			| '#'   | 'Item'    | 'Item key'   | 'Unit'   | 'Quantity'    |
			| '1'   | 'Dress'   | 'S/Yellow'   | 'pcs'    | '1,000'       |
			| '2'   | 'Dress'   | 'S/Yellow'   | 'pcs'    | '1,000'       |
		And I close all client application windows
		
		
				
						
			


		

		
				
		

		
			
	
		



