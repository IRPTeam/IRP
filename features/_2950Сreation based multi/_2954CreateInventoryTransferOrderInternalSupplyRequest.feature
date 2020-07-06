#language: ru
@tree
@Positive
Функционал: создание Inventory transfer order based on нескольких Internal supply request


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий



Сценарий: _295400 preparation 
	* Создание первого Internal supply request со склада Store 02
		* Open a creation form Internal Supply Request
			И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение номера документа
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '295'
		* Filling in basic details документа
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company | 
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
		* Filling in the tabular part
			И я нажимаю на кнопку'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'High shoes'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'       | 'Item key' |
				| 'High shoes' | '37/19SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	* Создание второго Internal supply request со склада Store 02
		* Open a creation form Internal Supply Request
			И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение номера документа
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '296'
		* Filling in basic details документа
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company | 
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
		* Filling in the tabular part
			И я нажимаю на кнопку'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Dress' | 'S/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'High shoes'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'       | 'Item key' |
				| 'High shoes' | '37/19SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	* Создание третьего Internal supply request со склада Store 03
		* Open a creation form Internal Supply Request
			И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение номера документа
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '297'
		* Filling in basic details документа
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company | 
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 03  |
			И в таблице "List" я выбираю текущую строку
		* Filling in the tabular part
			И я нажимаю на кнопку'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'M/White' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'High shoes'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'       | 'Item key' |
				| 'High shoes' | '37/19SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'


Сценарий: _295401 Check filling inInventory transfer order при создании based on двух Internal supply request с одинаковым складом
	* Выбор InternalSupplyRequest
		И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
		И в таблице "List" я перехожу к строке:
			| 'Number'  |
			| '295' | 
		И в таблице 'List' я перехожу на одну строку вниз с выделением
	* Создание Inventory transfer order и проверка заполнения
		И я нажимаю на кнопку с именем 'FormDocumentInventoryTransferOrderGenerateInventoryTransferOrder'
		И     таблица "ItemList" содержит строки:
		| 'Item'       | 'Quantity' | 'Internal supply request'      | 'Item key'  | 'Unit' |
		| 'Dress'      | '2,000'    | 'Internal supply request 296*' | 'S/Yellow'  | 'pcs'  |
		| 'Trousers'   | '2,000'    | 'Internal supply request 295*' | '38/Yellow' | 'pcs'  |
		| 'Boots'      | '1,000'    | 'Internal supply request 295*' | '37/18SD'   | 'pcs'  |
		| 'Boots'      | '2,000'    | 'Internal supply request 296*' | '37/18SD'   | 'pcs'  |
		| 'High shoes' | '2,000'    | 'Internal supply request 295*' | '37/19SD'   | 'pcs'  |
		| 'High shoes' | '2,000'    | 'Internal supply request 296*' | '37/19SD'   | 'pcs'  |
	И Я закрыл все окна клиентского приложения

Сценарий: _295402 Check filling inInventory transfer order при создании based on двух Internal supply request с разными складами
	* Выбор InternalSupplyRequest
		И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
		И в таблице "List" я перехожу к строке:
			| 'Number'  |
			| '296' | 
		И в таблице 'List' я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentInventoryTransferOrderGenerateInventoryTransferOrder'
		И в таблице "Stores" я перехожу к строке:
			| 'Store'    |
			| 'Store 03' |
		И в таблице "Stores" я устанавливаю флаг 'Use'
		И в таблице "Stores" я завершаю редактирование строки
		И я нажимаю на кнопку 'Ok'
	* Создание Inventory transfer order и проверка заполнения
		И     таблица "ItemList" содержит строки:
		| 'Item'       | 'Quantity' | 'Internal supply request'      | 'Item key' | 'Unit' |
		| 'Dress'      | '2,000'    | 'Internal supply request 297*' | 'M/White'  | 'pcs'  |
		| 'Boots'      | '2,000'    | 'Internal supply request 297*' | '37/18SD'  | 'pcs'  |
		| 'High shoes' | '2,000'    | 'Internal supply request 297*' | '37/19SD'  | 'pcs'  |
	И Я закрыл все окна клиентского приложения