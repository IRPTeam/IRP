#language: ru
@tree
@Positive


Функционал: объединение товара в наборы

Как разработчик
Я хочу создать документ Bundling
Чтобы продавать товар совместно

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: _029500 создание тестовых данных
	* Создание склада ордерного на приемку и неордерного на отгрузку
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Stores'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Store 07'
		И в поле с именем 'Description_tr' я ввожу текст 'Store 07 TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг с именем 'UseGoodsReceipt'
		И я снимаю флаг с именем 'UseShipmentConfirmation'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 2
	* Создание склада ордерного на отгрузку и неордерного на приемку
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Stores'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Store 08'
		И в поле с именем 'Description_tr' я ввожу текст 'Store 08 TR'
		И я нажимаю на кнопку 'Ok'
		И я снимаю флаг с именем 'UseGoodsReceipt'
		И я устанавливаю флаг с именем 'UseShipmentConfirmation'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 2
		И Я закрыл все окна клиентского приложения


Сценарий: _029501 создание документа Bundling с неордерного склада
	И Я закрыл все окна клиентского приложения
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-265' с именем 'IRP-265'
	И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я меняю номер документа
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '1'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Item bundle"
	И в таблице "List" я перехожу к строке:
		| 'Description'       |
		| 'Bound Dress+Shirt' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля с именем "Unit"
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Store"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Store 01'  |
	И в таблице "List" я выбираю текущую строку
	И в поле с именем 'Quantity' я ввожу текст '10,000'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Item key"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
	И в таблице "List" я перехожу к строке:
		| 'Item'  | 'Item key' |
		| 'Dress' | 'XS/Blue'  |
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
	И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1,000'
	И в таблице "ItemList" я завершаю редактирование строки
	И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Shirt'       |
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Item key"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
	И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1,000'
	И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5

Сценарий: _029502 проверка автоматического создания спецификации по созданному Bundle
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-265' с именем 'IRP-265'
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Catalog.Specifications'
	И в таблице "List" я перехожу к строке:
		| 'Description' | 'Type'   |
		| 'Dress+Shirt' | 'Bundle' |
	И в таблице "List" я выбираю текущую строку
	И     элемент формы с именем "Type" стал равен 'Bundle'
	И     элемент формы с именем "ItemBundle" стал равен 'Bound Dress+Shirt'
	И     таблица "FormTable*" содержит строки:
		| 'Size' | 'Color' | 'Quantity' |
		| 'XS'   | 'Blue'  | '1*'    |
	И Я закрываю текущее окно

Сценарий: _029503 проверка проводок по документу Bundling с неордерного склада по регистру StockBalance
# В случае неордерного склада по регистру приходуется Бандл и списывается товар из бандла
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'               | 'Store'    | 'Item key'                      |
	| '10,000'   | 'Bundling 1*'            | 'Store 01' | 'Bound Dress+Shirt/Dress+Shirt' |
	| '10,000'   | 'Bundling 1*'            | 'Store 01' | 'XS/Blue'                       |
	| '10,000'   | 'Bundling 1*'            | 'Store 01' | '36/Red'                        |
	И Я закрыл все окна клиентского приложения

Сценарий: _029504 проверка проводок по документу Bundling с неордерного склада по регистру StockReservation
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'               | 'Store'    | 'Item key'                      |
	| '10,000'   | 'Bundling 1*'            | 'Store 01' | 'Bound Dress+Shirt/Dress+Shirt' |
	| '10,000'   | 'Bundling 1*'            | 'Store 01' | 'XS/Blue'                       |
	| '10,000'   | 'Bundling 1*'            | 'Store 01' | '36/Red'                        |
	И Я закрыл все окна клиентского приложения

Сценарий: _029505 проверка отсутствия проводок по документу Bundling с неордерного склада по регистру GoodsInTransitIncoming
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" не содержит строки:
		| 'Recorder'                 |
		| 'Bundling 1*'              |
	И Я закрыл все окна клиентского приложения

Сценарий: _029506 проверка отсутствия проводок по документу Bundling с неордерного склада по регистру GoodsInTransitOutgoing
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" не содержит строки:
		| 'Recorder'                 |
		| 'Bundling 1*'              |
	И Я закрыл все окна клиентского приложения

Сценарий: _029507 создание документа Bundling с ордерного склада
	И Я закрыл все окна клиентского приложения
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-265' с именем 'IRP-265'
	И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я меняю номер документа
			И в поле 'Number' я ввожу текст '2'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Item bundle"
	И в таблице "List" я перехожу к строке:
		| 'Description'       |
		| 'Bound Dress+Trousers' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля с именем "Unit"
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Store"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Store 02'  |
	И в таблице "List" я выбираю текущую строку
	И в поле с именем 'Quantity' я ввожу текст '7,000'
	И я перехожу к закладке "Item list"
	И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Item key"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
	И в таблице "List" я перехожу к строке:
		| 'Item'  | 'Item key' |
		| 'Dress' | 'XS/Blue'  |
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
	И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
	И в таблице "ItemList" я завершаю редактирование строки
	И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Trousers'       |
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле "Item key"
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
	И в таблице "List" я перехожу к строке:
		| 'Item key'  |
		| '36/Yellow' |
	И в таблице "List" я выбираю текущую строку
	И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
	И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
	И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5

Сценарий: _029508 проверка автоматического создания дополнительной спецификации по созданному Bundle
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-265' с именем 'IRP-265'
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Catalog.Specifications'
	И в таблице "List" я перехожу к строке:
		| 'Description' | 'Type'   |
		| 'Dress+Trousers' | 'Bundle' |
	И в таблице "List" я выбираю текущую строку
	Тогда элемент формы с именем "Description_en" стал равен 'Dress+Trousers'
	И     элемент формы с именем "Type" стал равен 'Bundle'
	И     элемент формы с именем "ItemBundle" стал равен 'Bound Dress+Trousers'
	И     таблица "FormTable*" содержит строки:
		| 'Size' | 'Color' | 'Quantity' |
		| 'XS'   | 'Blue'  | '2*'    |
	И Я закрыл все окна клиентского приложения



Сценарий: _029509 проверка отсутствия проводок по документу Bundling с ордерного склада по регистру StockBalance
# В случае неордерного склада по регистру приходуется Бандл и списывается товар из бандла
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'                 | 'Store'    | Item key             |
	| '7,000'    | 'Bundling 2*'              | 'Store 02' | Bound Dress+Trousers |
	| '14,000'   | 'Bundling 2*'              | 'Store 02' | XS/Blue              |
	| '14,000'   | 'Bundling 2*'              | 'Store 02' | 36/Yellow            |
	И Я закрыл все окна клиентского приложения

Сценарий: _029510 проверка проводок по документу Bundling с ордерного склада по регистру StockReservation
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key'                      |
	| '14,000'   | 'Bundling 2*'     | 'Store 02' | 'XS/Blue'                       |
	| '14,000'   | 'Bundling 2*'     | 'Store 02' | '36/Yellow'                     |
	Тогда таблица "List" не содержит строки:
	| 'Quantity' | 'Recorder'                 | 'Store'    | 'Item key'             |
	| '7,000'    | 'Bundling 2*'              | 'Store 02' | 'Bound Dress+Trousers' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029511 проверка проводок по документу Bundling с ордерного склада по регистру GoodsInTransitIncoming
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Receipt basis'         | 'Store'    | 'Item key'                            |
		| '7,000'    | 'Bundling 2*'           | 'Bundling 2*'           | 'Store 02' | 'Bound Dress+Trousers/Dress+Trousers' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029512 проверка проводок по документу Bundling с ордерного склада по регистру GoodsInTransitOutgoing
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'                 | 'Shipment basis'        | 'Store'    | 'Item key'  |
	| '14,000'   | 'Bundling 2*'              | 'Bundling 2*'           | 'Store 02' | 'XS/Blue'   |
	| '14,000'   | 'Bundling 2*'              | 'Bundling 2*'           | 'Store 02' | '36/Yellow' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029513 создание расходного и приходного ордеров по документу Bundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
	И в таблице "List" я перехожу к строке:
		| 'Item bundle'          | 'Number' |
		| 'Bound Dress+Trousers' | '2'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем "FormDocumentGoodsReceiptGenerateGoodsReceipt"
	И     элемент формы с именем "Company" стал равен 'Main Company'
	И в поле 'Number' я ввожу текст '151'
	Тогда открылось окно '1C:Enterprise'
	И я нажимаю на кнопку 'Yes'
	И в поле 'Number' я ввожу текст '151'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И я нажимаю на кнопку с именем "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	И     элемент формы с именем "Company" стал равен 'Main Company'
	И в поле 'Number' я ввожу текст '151'
	Тогда открылось окно '1C:Enterprise'
	И я нажимаю на кнопку 'Yes'
	И в поле 'Number' я ввожу текст '151'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И Я закрываю текущее окно

Сценарий: _029514 проверка проводок расходного и приходного ордеров по документу Bundling
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                   | 'Store'    | 'Item key'             |
		| '7,000'    | 'Goods receipt 151*'         | 'Store 02' | 'Bound Dress+Trousers/Dress+Trousers' |
		| '14,000'   | 'Shipment confirmation 151*' | 'Store 02' | 'XS/Blue'              |
		| '14,000'   | 'Shipment confirmation 151*' | 'Store 02' | '36/Yellow'            |
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Store'    | 'Item key'                     |
		| '7,000'    | 'Goods receipt 151*'          | 'Store 02' | 'Bound Dress+Trousers/Dress+Trousers' |
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                | 'Receipt basis'         | 'Store'    | 'Item key'| 
		| '7,000'    | 'Goods receipt 151*'      | 'Bundling 2*'         | 'Store 02' | 'Bound Dress+Trousers/Dress+Trousers' |
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                   | 'Shipment basis'       | 'Store'    | 'Item key'  |
		| '14,000'   | 'Shipment confirmation 151*' | 'Bundling 2*'          | 'Store 02' | 'XS/Blue'   |
		| '14,000'   | 'Shipment confirmation 151*' | 'Bundling 2*'          | 'Store 02' | '36/Yellow' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029515 проверка автоматического создания ItemKey по бандлам
	И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
	И в таблице "List" я перехожу к строке:
		| Description       | Item type |
		| Bound Dress+Shirt | Сlothes   |
	И в таблице "List" я выбираю текущую строку
	И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
	И в таблице "List" я перехожу к строке:
		| Item key                      |
		| Bound Dress+Shirt/Dress+Shirt |
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
	И в таблице "List" я перехожу к строке:
		| Description          | Item type |
		| Bound Dress+Trousers | Сlothes   |
	И в таблице "List" я выбираю текущую строку
	И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
	И в таблице "List" я перехожу к строке:
		| Item key                            |
		| Bound Dress+Trousers/Dress+Trousers |
	И Я закрыл все окна клиентского приложения

Сценарий: _029516 проверка дублирования спецификаций при создании того же самого бандла
	И я создаю бандл
		И Я закрыл все окна клиентского приложения
		# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-265' с именем 'IRP-265'
		И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Bound Dress+Shirt' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И Пауза 5
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Specifications'
		Тогда таблица "List" стала равной:
			| 'Description'    | 'Type'   |
			| 'A-8'            | 'Set'    |
			| 'S-8'            | 'Set'    |
			| 'Dress+Shirt'    | 'Bundle' |
			| 'Dress+Trousers' | 'Bundle' |

Сценарий: _029517 проверка создания спецификации при формировании Bundle на один и тот же товар
	И я создаю бандл
		# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-265' с именем 'IRP-265'
		И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю номер документа
			И в поле 'Number' я ввожу текст '4'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '4'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Trousers    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '10,000'
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Trousers    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item     | Item key  |
			| Trousers | 38/Yellow |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Trousers    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И Пауза 10
	И я проверяю создание Item key на бандл по Trousers
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
		И в таблице "List" я перехожу к строке:
			| Description    | Item type |
			| Trousers       | Сlothes   |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		И в таблице "List" я перехожу к строке:
			| Item key          |
			| Trousers/Trousers |
		И Я закрыл все окна клиентского приложения
	И я проверяю автоматически созданную спецификацию на Set
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Specifications'
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Type'   |
			| 'Trousers' | 'Set' |
		И в таблице "List" я выбираю текущую строку
		Тогда элемент формы с именем "Description_en" стал равен 'Trousers'
		И     элемент формы с именем "Type" стал равен 'Set'
		И     таблица "FormTable*" содержит строки:
			| 'Size' | 'Color'  | 'Quantity' |
			| '36'   | 'Yellow' | '2,000'    |
			| '38'   | 'Yellow' | '2,000'    |
		И     элемент формы с именем "ItemField*" стал равен 'Сlothes'
		И Я закрыл все окна клиентского приложения
	И я проверяю проводки по регистрам
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                    | 'Store'    | 'Item key'             |
			| '10,000'   | 'Bundling 4*'                 | 'Store 01' | 'Trousers/Trousers'    |
			| '20,000'   | 'Bundling 4*'                 | 'Store 01' | '36/Yellow'            |
			| '20,000'   | 'Bundling 4*'                 | 'Store 01' | '38/Yellow'            |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                    | 'Store'    | 'Item key'          |
			| '10,000'   | 'Bundling 4*'                 | 'Store 01' | 'Trousers/Trousers' |
			| '20,000'   | 'Bundling 4*'                 | 'Store 01' | '36/Yellow'         |
			| '20,000'   | 'Bundling 4*'                 | 'Store 01' | '38/Yellow'         |
		И Я закрыл все окна клиентского приложения

Сценарий: _029518 создание Bundle на 2 разных свойства + одно повторяющееся одного и того же товара + 1 другой товар
	И я создаю бандл
		# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-265' с именем 'IRP-265'
		И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю номер документа
			И в поле 'Number' я ввожу текст '5'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '5'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Bound Dress+Shirt    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key  |
			| Dress | XS/Blue |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key  |
			| Dress | XS/Blue |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key  |
			| Dress | L/Green |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Shirt    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key  |
			| Shirt | 36/Red |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И Пауза 10
	И я проверяю создание Item key на бандл по Dress+Shirt
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
		И в таблице "List" я перехожу к строке:
			| Description         | Item type |
			| Bound Dress+Shirt   | Сlothes   |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		И таблица "List" содержит строки:
			| Item key                      |
			| Bound Dress+Shirt/Dress+Shirt |
			| Bound Dress+Shirt/Dress+Shirt |
		И Я закрыл все окна клиентского приложения
	И я проверяю автоматически созданную спецификацию на бандл
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Specifications'
		И в таблице "List" я перехожу к последней строке
		И в таблице "List" я выбираю текущую строку
		Тогда элемент формы с именем "Description_en" стал равен 'Dress+Shirt'
		И     элемент формы с именем "Type" стал равен 'Bundle'
		И     таблица "FormTable*" содержит строки:
			| 'Size' | 'Color' | 'Quantity' |
			| 'XS'   | 'Blue'  | '2,000'    |
			| 'XS'   | 'Blue'  | '2,000'    |
			| 'L'    | 'Green' | '2,000'    |
		И Я закрыл все окна клиентского приложения
	И я проверяю проводки по регистрам
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'              	| 'Store'    | 'Item key'             |
			| '2,000'      | 'Bundling 5*'          | 'Store 01' | 'Bound Dress+Shirt/Dress+Shirt'     |
			| '4,000'      | 'Bundling 5*'          | 'Store 01' | 'XS/Blue'                           |
			| '4,000'      | 'Bundling 5*'          | 'Store 01' | 'XS/Blue'                           |
			| '4,000'      | 'Bundling 5*'          | 'Store 01' | 'L/Green'                           |
			| '4,000'      | 'Bundling 5*'          | 'Store 01' | '36/Red'                            |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key'             |
			| '2,000'      | 'Bundling 5*'         | 'Store 01' | 'Bound Dress+Shirt/Dress+Shirt'     |
			| '8,000'      | 'Bundling 5*'         | 'Store 01' | 'XS/Blue'                           |
			| '4,000'      | 'Bundling 5*'         | 'Store 01' | 'L/Green'                           |
			| '4,000'      | 'Bundling 5*'         | 'Store 01' | '36/Red'                            |
		И Я закрыл все окна клиентского приложения

Сценарий: _029519 создание документа Bundling с ордерного склада на приемку товара и проверка движений
	* Открытие формы создания Bundle
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Изменение номера документа
			И в поле 'Number' я ввожу текст '7'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '7'
	* Заполнение реквизитов
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Bound Dress+Trousers' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 07'  |
		И в таблице "List" я выбираю текущую строку
	* Заполнение табличной части по товарам
		И в поле с именем 'Quantity' я ввожу текст '7,000'
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| '36/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Проведение документа и проверка движений
		И я нажимаю на кнопку 'Post'
		И Пауза 5
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Bundling 7*'                           | ''            | ''          | ''                                    | ''           | ''              | ''                                    | ''        |
		| 'Document registrations records'        | ''            | ''          | ''                                    | ''           | ''              | ''                                    | ''        |
		| 'Register  "Bundle contents"'           | ''            | ''          | ''                                    | ''           | ''              | ''                                    | ''        |
		| ''                                      | 'Period'      | 'Resources' | 'Dimensions'                          | ''           | ''              | ''                                    | ''        |
		| ''                                      | ''            | 'Quantity'  | 'Item key bundle'                     | 'Item key'   | ''              | ''                                    | ''        |
		| ''                                      | '*'           | '2'         | 'Bound Dress+Trousers/Dress+Trousers' | 'XS/Blue'    | ''              | ''                                    | ''        |
		| ''                                      | '*'           | '2'         | 'Bound Dress+Trousers/Dress+Trousers' | '36/Yellow'  | ''              | ''                                    | ''        |
		| ''                                      | ''            | ''          | ''                                    | ''           | ''              | ''                                    | ''        |
		| 'Register  "Goods in transit incoming"' | ''            | ''          | ''                                    | ''           | ''              | ''                                    | ''        |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''              | ''                                    | ''        |
		| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Receipt basis' | 'Item key'                            | 'Row key' |
		| ''                                      | 'Receipt'     | '*'         | '7'                                   | 'Store 07'   | 'Bundling 7*'   | 'Bound Dress+Trousers/Dress+Trousers' | '*'       |
		| ''                                      | ''            | ''          | ''                                    | ''           | ''              | ''                                    | ''        |
		| 'Register  "Stock reservation"'         | ''            | ''          | ''                                    | ''           | ''              | ''                                    | ''        |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''              | ''                                    | ''        |
		| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Item key'      | ''                                    | ''        |
		| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 07'   | 'XS/Blue'       | ''                                    | ''        |
		| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 07'   | '36/Yellow'     | ''                                    | ''        |
		| ''                                      | ''            | ''          | ''                                    | ''           | ''              | ''                                    | ''        |
		| 'Register  "Stock balance"'             | ''            | ''          | ''                                    | ''           | ''              | ''                                    | ''        |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''              | ''                                    | ''        |
		| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Item key'      | ''                                    | ''        |
		| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 07'   | 'XS/Blue'       | ''                                    | ''        |
		| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 07'   | '36/Yellow'     | ''                                    | ''        |
		И Я закрыл все окна клиентского приложения

Сценарий: _029520 создание документа Bundling с ордерного склада на отгрузку товара  и проверка движений
	* Открытие формы создания Bundle
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Изменение номера документа
		И в поле 'Number' я ввожу текст '8'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '8'
	* Заполнение реквизитов
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Bound Dress+Trousers' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 08'  |
		И в таблице "List" я выбираю текущую строку
	* Заполнение табличной части по товарам
		И в поле с именем 'Quantity' я ввожу текст '7,000'
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| '36/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListQuantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Проведение документа и проверка движений
		И я нажимаю на кнопку 'Post'
		И Пауза 5
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Bundling 8*'                           | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Document registrations records'        | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Register  "Bundle contents"'           | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| ''                                      | 'Period'      | 'Resources' | 'Dimensions'                          | ''           | ''                                    | ''          | ''        |
			| ''                                      | ''            | 'Quantity'  | 'Item key bundle'                     | 'Item key'   | ''                                    | ''          | ''        |
			| ''                                      | '*'           | '2'         | 'Bound Dress+Trousers/Dress+Trousers' | 'XS/Blue'    | ''                                    | ''          | ''        |
			| ''                                      | '*'           | '2'         | 'Bound Dress+Trousers/Dress+Trousers' | '36/Yellow'  | ''                                    | ''          | ''        |
			| ''                                      | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Register  "Goods in transit outgoing"' | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''                                    | ''          | ''        |
			| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Shipment basis'                      | 'Item key'  | 'Row key' |
			| ''                                      | 'Receipt'     | '*'         | '14'                                  | 'Store 08'   | 'Bundling 8*'                         | 'XS/Blue'   | '*'       |
			| ''                                      | 'Receipt'     | '*'         | '14'                                  | 'Store 08'   | 'Bundling 8*'                         | '36/Yellow' | '*'       |
			| ''                                      | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Register  "Stock reservation"'         | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''                                    | ''          | ''        |
			| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Item key'                            | ''          | ''        |
			| ''                                      | 'Receipt'     | '*'         | '7'                                   | 'Store 08'   | 'Bound Dress+Trousers/Dress+Trousers' | ''          | ''        |
			| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 08'   | 'XS/Blue'                             | ''          | ''        |
			| ''                                      | 'Expense'     | '*'         | '14'                                  | 'Store 08'   | '36/Yellow'                           | ''          | ''        |
			| ''                                      | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| 'Register  "Stock balance"'             | ''            | ''          | ''                                    | ''           | ''                                    | ''          | ''        |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'                           | 'Dimensions' | ''                                    | ''          | ''        |
			| ''                                      | ''            | ''          | 'Quantity'                            | 'Store'      | 'Item key'                            | ''          | ''        |
			| ''                                      | 'Receipt'     | '*'         | '7'                                   | 'Store 08'   | 'Bound Dress+Trousers/Dress+Trousers' | ''          | ''        |
		И Я закрыл все окна клиентского приложения
