#language: ru
@tree
@Positive


Функционал: add items to documents by barcode

Как разработчик
Я хочу добавить функционал по добавлению товара в документы по штрих-коду
Для работы с товаром


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _300701 barcode check in Sales order + price and tax filling
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	Когда check the barcode search in the sales documents + price and tax filling in

Сценарий: _300702 barcode check in Sales invoice + price and tax filling
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	Когда check the barcode search in the sales documents + price and tax filling in

Сценарий: _300703 barcode check in Sales return + price and tax filling
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	Когда check the barcode search on the return documents

Сценарий: _300704 barcode check in Sales return order + price and tax filling
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	Когда check the barcode search on the return documents

Сценарий: _300705 barcode check in Purchase order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	Когда check the barcode search in the purchase/purchase returns

Сценарий: _300706 barcode check in Purchase invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
		| Description |
		| Partner Kalipso     |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку 'SearchByBarcode'
	И в поле 'InputFld' я ввожу текст '2202283713'
	И я нажимаю на кнопку 'OK'
	И я проверяю добавление товара и заполнение цены в табличной части
		И     таблица "ItemList" содержит строки:
			| 'Item'  |'Item key' |'Q'     | 'Unit' |
			| 'Dress TR' |'S/Yellow TR'  |'1,000' | 'adet'  |
	И Я закрыл все окна клиентского приложения

Сценарий: _300707 barcode check in Purchase return order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	Когда check the barcode search in the purchase/purchase returns

Сценарий: _300708 barcode check in Purchase return
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	Когда check the barcode search in the purchase/purchase returns

Сценарий: _300709 barcode check in Goods reciept
	И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
	Когда check the barcode search in storage operations documents

Сценарий: _300710 barcode check in Shipment confirmation
	И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
	Когда check the barcode search in storage operations documents

Сценарий: _300711 barcode check in Inventory transfer
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	Когда check the barcode search in storage operations documents

Сценарий: _300712 barcode check in Inventory transfer order
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
	Когда check the barcode search in storage operations documents

Сценарий: _300713 barcode check in Internal Supply Request
	И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
	Когда check the barcode search in storage operations documents


Сценарий: _300716 barcode check in Bundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
	Когда check the barcode search in the product bundling documents

Сценарий: _300717 barcode check in Unbundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	Когда check the barcode search in the product bundling documents

Сценарий: _300718 barcode check in StockAdjustmentAsSurplus
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
	Когда check the barcode search in storage operations documents

Сценарий: _300719 barcode check in StockAdjustmentAsWriteOff
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
	Когда check the barcode search in storage operations documents


Сценарий: _300720 barcode check in PhysicalInventory
	И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
	Когда check the barcode search in the PhysicalInventory documents

Сценарий: _300721 barcode check in PhysicalCountByLocation
	И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
	Когда check the barcode search in storage operations documents