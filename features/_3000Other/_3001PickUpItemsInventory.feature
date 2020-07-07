#language: ru
@tree
@Positive
Функционал: форма подбора товаров в складских документах



Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.

Сценарий: _3001001 проверка формы подбора товара в документе StockAdjustmentAsWriteOff
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение шапки документа
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Main Company'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'      |
		И в таблице "List" я выбираю текущую строку
	* Проверка формы подбора товара
		Когда проверяю форму подбора товара в StockAdjustmentAsWriteOff/StockAdjustmentAsSurplus
	И Я закрыл все окна клиентского приложения


Сценарий: _3001002 проверка формы подбора товара в документе StockAdjustmentAsSurplus
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение шапки документа
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Main Company'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'      |
		И в таблице "List" я выбираю текущую строку
	* Проверка формы подбора товара
		Когда проверяю форму подбора товара в StockAdjustmentAsWriteOff/StockAdjustmentAsSurplus
	И Я закрыл все окна клиентского приложения

Сценарий: 3001003 проверка формы подбора товара в документе PhysicalInventory
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение шапки документа
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'      |
		И в таблице "List" я выбираю текущую строку
	* Проверка формы подбора товара
		Когда проверяю форму подбора товара в PhysicalInventory
	И Я закрыл все окна клиентского приложения

Сценарий: 3001004 проверка формы подбора товара в документе PhysicalCountByLocation
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение шапки документа
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'      |
		И в таблице "List" я выбираю текущую строку
	* Проверка формы подбора товара
		Когда проверяю форму подбора товара в PhysicalInventory
	И Я закрыл все окна клиентского приложения



Сценарий: 3001005 проверка формы подбора товара в Inventory Transfer Order
	* Открытие формы для создания Inventory Transfer Order
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение шапки Inventory Transfer Order
		И я нажимаю кнопку выбора у поля "Store sender"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store receiver"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 06'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Проверка формы подбора товара
		Когда проверяю форму подбора товара в InventoryTransferOrder/InventoryTransfer
	И Я закрыл все окна клиентского приложения


Сценарий: 3001006 проверка формы подбора товара в Inventory Transfer
	* Открытие формы для создания Inventory Transfer Order
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение шапки Inventory Transfer
		И я нажимаю кнопку выбора у поля "Store sender"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store receiver"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 06'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Проверка формы подбора товара
		Когда проверяю форму подбора товара в InventoryTransferOrder/InventoryTransfer
	И Я закрыл все окна клиентского приложения

Сценарий: 3001007 проверка формы подбора товара в Internal supply request
	* Открытие формы для создания Internal supply request
		И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение шапки Internal supply request
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Проверка формы подбора товара
		Когда проверяю форму подбора товара в StockAdjustmentAsWriteOff/StockAdjustmentAsSurplus
	И Я закрыл все окна клиентского приложения