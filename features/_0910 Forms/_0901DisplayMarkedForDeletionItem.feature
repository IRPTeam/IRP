#language: ru
@tree
@Positive


Функционал: check that the item marked for deletion is not displayed


As a developer
I want to hide the items marked for deletion from the product selection form.
So the user can't select it in the sales and purchase documents


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _090201 check that the items marked for deletion is not displayed in the PurchaseOrder
	* Temporary markup for deletion Item Box
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
		И в таблице "List" я перехожу к строке:
		| Description |
		| Box         |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description          |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090202 check that the items marked for deletion is not displayed in the Purchase invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090203 check that the items marked for deletion is not displayed in the Sales order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090204 check that the items marked for deletion is not displayed in the Sales invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения


Сценарий: _090205 check that the items marked for deletion is not displayed in the Inventory transfer
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090206 check that the items marked for deletion is not displayed in the Inventory transfer order
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку "Add"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090207 check that the items marked for deletion is not displayed in the Internal Supply Request
	И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку "Add"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090208 check that the items marked for deletion is not displayed in the Purchase return order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090209 check that the items marked for deletion is not displayed in the Purchase return
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090210 check that the items marked for deletion is not displayed in the Sales Return
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090211 check that the items marked for deletion is not displayed in the Sales return order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090212 check that the items marked for deletion is not displayed in the GoodsReceipt
	И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090213 check that the items marked for deletion is not displayed in the Shipment Confirmation
	И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения


Сценарий: _090216 check that the items marked for deletion is not displayed in the Bundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Item bundle"
	Тогда открылось окно 'Items'
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрываю окно 'Items'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я нажимаю на кнопку 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090217 check that the items marked for deletion is not displayed in the Unbundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Item bundle"
	Тогда открылось окно 'Items'
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрываю окно 'Items'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я нажимаю на кнопку 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090218 check that the items marked for deletion is not displayed in the PhysicalInventory
	И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку "Add"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090219 check that the items marked for deletion is not displayed in the StockAdjustmentAsSurplus
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку "Add"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения

Сценарий: _090220 check that the items marked for deletion is not displayed in the StockAdjustmentAsWriteOff
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю на кнопку "Add"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	Тогда таблица "List" не содержит строки:
		| Description       |
		| Box               |
	И Я закрыл все окна клиентского приложения