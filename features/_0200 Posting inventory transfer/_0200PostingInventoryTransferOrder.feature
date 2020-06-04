#language: ru
@tree
@Positive
Функционал: проведение документа Заказ на перемещение товаров по регистрам складского учета

Как Разработчик
Я хочу создать проводки документа Заказ на перемещение товаров
Для того чтобы фиксировать какой товар планируется переместить

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

# 1
Сценарий: _020001 создание документа Заказ на перемещение (InventoryTransferOrder) с неордерного склада на ордерный
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-197' с именем 'IRP-197'
	И я открываю форму для создания InventoryTransferOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю данные о складе отправителе и складе получателе
		И я нажимаю кнопку выбора у поля "Store sender"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store receiver"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	И я меняю номер перемещения
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '201'
	И я заполняю данные по товарам для перемещения
		И я перехожу к закладке "Item list"
		И я нажимаю на кнопку с именем 'Add'
		Когда выбираю в заказе item Dress
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| 'M/White' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И я нажимаю на кнопку с именем 'FormChoose'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '50,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'Add'
		Когда выбираю в заказе item Dress
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| 'S/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Unit"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И я нажимаю на кнопку с именем 'FormChoose'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'

Сценарий: _020002 проверка движений документа InventoryTransferOrder с неордерного склада на ордерный по регистру TransferOrderBalance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                      |'Store sender' | 'Store receiver' | 'Order'                       | 'Item key' |
		| '10,000'   | 'Inventory transfer order 201*' |'Store 01'     | 'Store 02'       | 'Inventory transfer order 201*' | 'S/Yellow' |
		| '50,000'   | 'Inventory transfer order 201*' |'Store 01'     | 'Store 02'       | 'Inventory transfer order 201*' | 'M/White'  |

Сценарий: _020003 проверка движений документа InventoryTransferOrder с неордерного склада на ордерный по регистру StockReservation
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                      |'Store'    | 'Item key' |
	| '10,000'   | 'Inventory transfer order 201*' |'Store 01' | 'S/Yellow' |
	| '50,000'   | 'Inventory transfer order 201*' |'Store 01' | 'M/White'  |




# 2
Сценарий: _020004 создание документа Заказ на перемещение (InventoryTransferOrder) между двумя ордерными складами
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-197' с именем 'IRP-197'
	И я открываю форму для создания Inventory Transfer Order
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю данные о складе отправителе и складе получателе
		И я нажимаю кнопку выбора у поля "Store sender"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store receiver"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'  |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	И я меняю номер перемещения
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '202'
	И я заполняю данные по товарам для перемещения
		И я перехожу к закладке "Item list"
		И я нажимаю на кнопку с именем 'Add'
		Когда выбираю в заказе item Dress
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| 'L/Green' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Unit"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И я нажимаю на кнопку с именем 'FormChoose'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '20,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'

Сценарий: _020005 проверка движений документа InventoryTransferOrder между двумя ордерными складами по регистру TransferOrderBalance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key' |
		| '20,000'   | 'Inventory transfer order 202*' | '1'           | 'Store 02'     | 'Store 03'       | 'Inventory transfer order 202*' | 'L/Green'  |

Сценарий: _020006 проверка движений документа InventoryTransferOrder между двумя ордерными складами по регистру StockReservation
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key' |
	| '20,000'   | 'Inventory transfer order 202*' | '1'           | 'Store 02' | 'L/Green'  |

# 3
Сценарий: _020007 создание документа Заказ на перемещение (InventoryTransferOrder) с ордерного на неордерный склад
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-197' с именем 'IRP-197'
	И я открываю форму для создания Inventory Transfer Order
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю данные о складе отправителе и складе получателе
		И я нажимаю кнопку выбора у поля "Store sender"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store receiver"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	И я меняю номер перемещения
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '203'
	И я заполняю данные по товарам для перемещения
		И я перехожу к закладке "Item list"
		И я нажимаю на кнопку с именем 'Add'
		Когда выбираю в заказе item Dress
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| 'L/Green' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Unit"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И я нажимаю на кнопку с именем 'FormChoose'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '17,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'


Сценарий: _020008 проверка движений документа InventoryTransferOrder с ордерного на неордерный склад по регистру TransferOrderBalance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key' |
		| '17,000'   | 'Inventory transfer order 203*' | '1'           | 'Store 02'     | 'Store 01'       | 'Inventory transfer order 203*' | 'L/Green'  |

Сценарий: _020009 проверка движений документа InventoryTransferOrder с ордерного на неордерный склад по регистру StockReservation
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key' |
		| '17,000'   | 'Inventory transfer order 203*' | '1'           | 'Store 02' | 'L/Green'  |




# 4
Сценарий: _020010 создание документа Заказ на перемещение (InventoryTransferOrder) между двумя неордерными складами
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-197' с именем 'IRP-197'
	И я открываю форму для создания Inventory Transfer Order
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю данные о складе отправителе и складе получателе
		И я нажимаю кнопку выбора у поля "Store sender"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store receiver"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 04'  |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	И я меняю номер перемещения
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '204'
	И я заполняю данные по товарам для перемещения
		И я перехожу к закладке "Item list"
		И я нажимаю на кнопку с именем 'Add'
		Когда выбираю в заказе item Trousers
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| '36/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Unit"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И я нажимаю на кнопку с именем 'FormChoose'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'

Сценарий: _020011 проверка движений документа InventoryTransferOrder между двумя неордерными складами по регистру TransferOrderBalance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key'  |
		| '10,000'   | 'Inventory transfer order 204*' | '1'           | 'Store 01'     | 'Store 04'       | 'Inventory transfer order 204*' | '36/Yellow' |


Сценарий: _020012 проверка движений документа InventoryTransferOrder между двумя неордерными складами по регистру StockReservation
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key'  |
	| '10,000'   | 'Inventory transfer order 204*' | '1'           | 'Store 01' | '36/Yellow' |


Сценарий: _020013 проверка движений по статусам и истории статусов документа Inventory Transfer Order
	И Я закрыл все окна клиентского приложения
	И я содаю документ Inventory Transfer Order
		И я открываю форму для создания Inventory Transfer Order
			И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
		И я заполняю данные о складе отправителе и складе получателе
			И я нажимаю кнопку выбора у поля "Store sender"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store receiver"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
		И я проверяю установку статуса по умолчанию "Wait"
			И элемент формы с именем "Status" стал равен "Wait"
		И я устанавливаю номер документа 101
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '205'
		И я заполняю данные по товарам для перемещения
			И я перехожу к закладке "Item list"
			И я нажимаю на кнопку с именем 'Add'
			Когда выбираю в заказе item Dress
			И я перехожу к следующему реквизиту
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key'  |
				| 'L/Green' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Unit"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
			И я нажимаю на кнопку с именем 'FormChoose'
			И я перехожу к следующему реквизиту
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '20,000'
			И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И Я закрываю текущее окно
		И я проверяю отсутсвие движений при статусе Wait
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'                    |
				| 'Inventory transfer order 205*' |
			И Я закрываю текущее окно
		И я устанавливаю статус Approved - делает проводки
			И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
			И в таблице "List" я перехожу к строке:
				| 'Number'   | 'Store sender' | 'Store receiver' |
				| '205'      |  'Store 02'     | 'Store 03'       |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
			И я нажимаю на кнопку 'Post and close'
			И Я закрыл все окна клиентского приложения
		И я проверяю движения при статусе Approved
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
			Тогда таблица "List" содержит строки:
				| 'Recorder'                    |
				| 'Inventory transfer order 205*' |
			И Я закрываю текущее окно
		И я устанавливаю статус Send - делает проводки
			И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
			И в таблице "List" я перехожу к строке:
				| 'Number' | 'Store sender' | 'Store receiver' |
				| '205'      |  'Store 02'     | 'Store 03'       |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
			И из выпадающего списка "Status" я выбираю точное значение 'Send'
			И я нажимаю на кнопку 'Post and close'
			И Я закрываю текущее окно
		И я проверяю движения при статусе Send
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
			Тогда таблица "List" содержит строки:
				| 'Recorder'                    |
				| 'Inventory transfer order 205*' |
			И    Я закрыл все окна клиентского приложения
		И я устанавливаю статус Receive - делает проводки
			И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
			И в таблице "List" я перехожу к строке:
				| 'Number' | 'Store sender' | 'Store receiver' |
				| '205'      |  'Store 02'     | 'Store 03'       |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
			И из выпадающего списка "Status" я выбираю точное значение 'Receive'
			И я нажимаю на кнопку 'Post'
			И я нажимаю на гиперссылку "History"
			Тогда таблица "List" содержит строки:
				| 'Object'                         | 'Status'   |
				# | 'Inventory transfer order 205*' | 'Wait'     |
				| 'Inventory transfer order 205*' | 'Approved' |
				| 'Inventory transfer order 205*' | 'Send'     |
				| 'Inventory transfer order 205*' | 'Receive'  |
			И я закрываю текущее окно
			И я нажимаю на кнопку 'Post and close'
		И я проверяю движения при статусе Receive
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.TransferOrderBalance'
			Тогда таблица "List" содержит строки:
			| 'Recorder'                    |
			| 'Inventory transfer order 205*' |
			И Я закрываю текущее окно



	
