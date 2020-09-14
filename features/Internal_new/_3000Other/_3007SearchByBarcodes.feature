#language: en
@tree
@Positive
@Group18


Feature: add items to documents by barcode


Background:
	Given I launch TestClient opening script or connect the existing one


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
		| Description |
		| Partner Kalipso     |
	And I select current line in "List" table
	And I click "SearchByBarcode" button
	And I input "2202283713" text in "InputFld" field
	And I click "OK" button
	* Check adding an items and filling in the price in the tabular part
		And "ItemList" table contains lines
			| 'Item'  |'Item key' |'Q'     | 'Unit' |
			| 'Dress TR' |'S/Yellow TR'  |'1,000' | 'adet'  |
	And I close all client application windows

Scenario: _300707 barcode check in Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	When check the barcode search in the purchase/purchase returns

Scenario: _300708 barcode check in Purchase return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	When check the barcode search in the purchase/purchase returns

Scenario: _300709 barcode check in Goods reciept
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


Scenario: _300716 barcode check in Bundling
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
	When check the barcode search in storage operations documents
