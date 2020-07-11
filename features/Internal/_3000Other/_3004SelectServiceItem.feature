#language: ru
@tree
@Positive


Функционал: product / service selection filter

Как разработчик
Я хочу добавить фильтр по выбору товара/услуги
Для удобства добавления товара в документы закупки и перемещения


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.

# услуги доступны

Сценарий: _300401 check filter on the choice of services in the document Purchase order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" содержит строки:
		| Description          |
		| Dress TR             |
		| Service TR           |
		| Router               |
	И Я закрыл все окна клиентского приложения

Сценарий: _300402 check filter on the choice of services in the document Purchase invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" содержит строки:
		| Description          |
		| Dress TR             |
		| Service TR           |
		| Router               |
	И Я закрыл все окна клиентского приложения

Сценарий: _300403 check filter on the choice of services in the document Sales order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" содержит строки:
		| Description          |
		| Dress TR             |
		| Service TR           |
		| Router               |
	И Я закрыл все окна клиентского приложения


Сценарий: _300404 check filter on the choice of services in the document Sales invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" содержит строки:
		| Description          |
		| Dress TR             |
		| Service TR           |
		| Router               |
	И Я закрыл все окна клиентского приложения

# услуги не доступны

Сценарий: _300405 check filter on the choice of services in the document Inventory transfer
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения

Сценарий: _300406 check filter on the choice of services in the document Inventory transfer order
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения

Сценарий: _300407 check filter on the choice of services in the document Internal Supply Request
	И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
	И я нажимаю на кнопку с именем 'FormCreate'
	И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения

Сценарий: _300408 check filter on the choice of services in the document Purchase return order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения

Сценарий: _300409 check filter on the choice of services in the document Purchase return
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения

Сценарий: _300410 check filter on the choice of services in the document Sales Return
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения

Сценарий: _300411 check filter on the choice of services in the document Sales return order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения

Сценарий: _300412 check filter on the choice of services in the document GoodsReceipt
	И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения

Сценарий: _300413 check filter on the choice of services in the document Shipment Confirmation
	И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения


Сценарий: _300416 check filter on the choice of services in the document Bundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Item bundle"
	Тогда открылось окно 'Items'
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрываю окно 'Items'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я нажимаю на кнопку 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения

Сценарий: _300417 check filter on the choice of services in the document Unbundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Item bundle"
	Тогда открылось окно 'Items'
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрываю окно 'Items'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я нажимаю на кнопку 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения

Сценарий: _300418 check filter on the choice of services in the document StockAdjustmentAsSurplus
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения

Сценарий: _300419 check filter on the choice of services in the document StockAdjustmentAsWriteOff
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения

Сценарий: _300420 check filter on the choice of services in the document PhysicalInventory
	И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Service TR           |
	И Я закрыл все окна клиентского приложения