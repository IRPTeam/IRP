#language: ru
@tree
@Positive

Функционал: проверка механизма графика выполнения заказов

Как тестировщик
Я хочу проверить работу механизма графика выполнения заказов
Для того чтобы была возможность контролировать своевременность выполнения заказов


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _170001 проверка заполнение даты выполнения заказа в Sales order с ордерного + неордерного склада + с одинаковыми строками с разными датами отгрузки (прямая схема отгрузки)
	И я создаю тестовый заказ
		Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И я проставляю Delivery date
		И в таблице "ItemList" я перехожу к строке:
			| Item  | Item key |
			| Dress | XS/Blue  |
		И в таблице "ItemList" я активизирую поле с именем "ItemListDeliveryDate"
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '10.12.2019'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| Item  | Item key |
			| Boots | 36/18SD  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '28.11.2019'
	И я добавляю строку с неордерного склада
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 36/18SD  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '3,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '01.12.2019'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
	И я проверяю отображение даты доставки
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Item key' | 'Store'    | 'Delivery date' | 'Q'     |
		| 'Dress' | 'XS/Blue'  | 'Store 02' | '10.12.2019'    | '5,000' |
		| 'Boots' | '36/18SD'  | 'Store 02' | '28.11.2019'    | '1,000' |
		| 'Boots' | '36/18SD'  | 'Store 01' | '01.12.2019'    | '3,000' |
	Тогда я меняю номер документа и провожу заказ
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '421'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '421'
		И я нажимаю на кнопку 'Post'
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post'
	Тогда я проверяю проводки по регистру "Shipment confirmation schedule"
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.ShipmentConfirmationSchedule"
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'         |'Company'       | 'Order'            | 'Store'    | 'Item key' | 'Delivery date' |
		| '5,000'    | 'Sales order 421*' | 'Main Company' | 'Sales order 421*' | 'Store 02' | 'XS/Blue'  | '10.12.2019'    |
		| '1,000'    | 'Sales order 421*' | 'Main Company' | 'Sales order 421*' | 'Store 02' | '36/18SD'  | '28.11.2019'    |
		| '3,000'    | 'Sales order 421*' | 'Main Company' | 'Sales order 421*' | 'Store 01' | '36/18SD'  | '01.12.2019'    |
	И я закрыл все окна клиентского приложения


Сценарий: _170002 проверка заполнения даты выполнения заказа в Sales invoice с неордерного склада при создании на основании + добавление строки которой нет в заказе (прямая схема отгрузки)
	И я создаю на основании Sales order инвойс
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
		| 'Number'   |
		| '421'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormDocumentSalesInvoiceGenerateSalesInvoice"
	Тогда я проверяю заполнение даты отгрузки
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Item key' | 'Store'    |'Delivery date' | 'Sales order'      | 'Unit' | 'Q'     |
		| 'Dress' | 'XS/Blue'  | 'Store 02' |'10.12.2019'    | 'Sales order 421*' | 'pcs'  | '5,000' |
		| 'Boots' | '36/18SD'  | 'Store 02' |'28.11.2019'    | 'Sales order 421*' | 'pcs'  | '1,000' |
		| 'Boots' | '36/18SD'  | 'Store 01' |'01.12.2019'    | 'Sales order 421*' | 'pcs'  | '3,000' |
	И я добавляю строку которой нет в заказе (отгрузка с неордерного склада)
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | S/Yellow  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '09.12.2019'
	И я добавляю строку которой нет в заказе (отгрузка с ордерного склада)
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | S/Yellow  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '09.12.2019'
	Тогда я меняю номер документа и провожу инвойс
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '421'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '421'
		# И в поле 'Date' я ввожу текст '03.09.2019 14:00:24'
		И я перехожу к закладке "Item list"
		# сообщение по ценам
		И я нажимаю на кнопку 'Post'
	Тогда я проверяю проводки по регистру "Shipment confirmation schedule"
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.ShipmentConfirmationSchedule"
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'            | 'Company'     | 'Order'              | 'Store'    | 'Item key' | 'Delivery date' |
		| '5,000'    | 'Sales invoice 421*' | 'Main Company' | 'Sales order 421*'   | 'Store 02' | 'XS/Blue'  | '10.12.2019'    |
		| '1,000'    | 'Sales invoice 421*' | 'Main Company' | 'Sales order 421*'   | 'Store 02' | '36/18SD'  | '28.11.2019'    |
		| '2,000'    | 'Sales invoice 421*' | 'Main Company' | 'Sales invoice 421*' | 'Store 01' | 'S/Yellow' | '09.12.2019'    |
		| '8,000'    | 'Sales invoice 421*' | 'Main Company' | 'Sales invoice 421*' | 'Store 02' | 'S/Yellow' | '09.12.2019'    |
		| '3,000'    | 'Sales invoice 421*' | 'Main Company' | 'Sales order 421*'   | 'Store 01' | '36/18SD'  | '*'             |
		| '5,000'    | 'Sales invoice 421*' | 'Main Company' | 'Sales order 421*'   | 'Store 02' | 'XS/Blue'  | '10.12.2019'    |
		| '1,000'    | 'Sales invoice 421*' | 'Main Company' | 'Sales order 421*'   | 'Store 02' | '36/18SD'  | '28.11.2019'    |
		| '2,000'    | 'Sales invoice 421*' | 'Main Company' | 'Sales invoice 421*' | 'Store 01' | 'S/Yellow' | '*'             |
	И я закрыл все окна клиентского приложения


Сценарий: _170003 проверка фиксирования фактической даты отгрузки товара в Shipment confirmation (прямая схема отгрузки)
	И я создаю Shipment confirmation на основании Sales invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '421'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
		И я проверяю заполнение реквизитов
			И     элемент формы с именем "Company" стал равен 'Main Company'
			И     элемент формы с именем "Store" стал равен 'Store 02'
		И я меняю номер расходного ордера
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '421'
			И в поле 'Date' я ввожу текст '30.11.2019  0:00:00'
		И я нажимаю на кнопку 'Post and close'
	И я проверяю проводки документа по регистру "Shipment confirmation schedule"
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.ShipmentConfirmationSchedule"
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                   |'Company'      | 'Order'              | 'Store'    | 'Item key' | 'Delivery date' |
		| '8,000'    | 'Shipment confirmation 421*' |'Main Company' | 'Sales invoice 421*' | 'Store 02' | 'S/Yellow' | '30.11.2019'    |
		| '5,000'    | 'Shipment confirmation 421*' |'Main Company' | 'Sales invoice 421*' | 'Store 02' | 'XS/Blue'  | '30.11.2019'    |
		| '1,000'    | 'Shipment confirmation 421*' |'Main Company' | 'Sales invoice 421*' | 'Store 02' | '36/18SD'  | '30.11.2019'    |

Сценарий: _170004 проверка фиксирования фактической даты отгрузки в Shipment confirmation (непрямая схема отгрузки)
	И я создаю тестовый заказ
		Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И я проставляю Delivery date
		И в таблице "ItemList" я перехожу к строке:
			| Item  | Item key |
			| Dress | XS/Blue  |
		И в таблице "ItemList" в поле 'Q' я ввожу текст '12,000'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '25.12.2019'
		И в таблице "ItemList" я перехожу к строке:
			| Item  | Item key |
			| Boots | 36/18SD  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '11,000'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '21.12.2019'
	И я добавляю строку с неордерного склада
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 36/18SD  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '30,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'	
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '03.12.2019'
	И я проверяю отображение даты доставки
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Item key' | 'Store'    | 'Delivery date' | 'Q'     |
		| 'Dress' | 'XS/Blue'  | 'Store 02' | '25.12.2019'    | '12,000' |
		| 'Boots' | '36/18SD'  | 'Store 02' | '21.12.2019'    | '11,000' |
		| 'Boots' | '36/18SD'  | 'Store 01' | '03.12.2019'    | '30,000' |
	Тогда я меняю номер документа, признак схемы отгрузки и провожу заказ
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '422'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '422'
		И я изменяю флаг 'Shipment confirmations before sales invoice'
		И я нажимаю на кнопку 'Post'
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post'
	Тогда я проверяю проводки по регистру "Shipment confirmation schedule"
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.ShipmentConfirmationSchedule"
		Тогда таблица "List" содержит строки:
		| 'Quantity'  | 'Recorder'         |'Company'       | 'Order'            | 'Store'    | 'Item key' | 'Delivery date' |
		| '12,000'    | 'Sales order 422*' | 'Main Company' | 'Sales order 422*' | 'Store 02' | 'XS/Blue'  | '25.12.2019'    |
		| '11,000'    | 'Sales order 422*' | 'Main Company' | 'Sales order 422*' | 'Store 02' | '36/18SD'  | '21.12.2019'    |
		| '30,000'    | 'Sales order 422*' | 'Main Company' | 'Sales order 422*' | 'Store 01' | '36/18SD'  | '03.12.2019'    |
	И я закрыл все окна клиентского приложения
	И я создаю Shipment confirmation на основании Sales order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '422'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
		И я проверяю заполнение реквизитов
			И     элемент формы с именем "Company" стал равен 'Main Company'
			И     элемент формы с именем "Store" стал равен 'Store 02'
		И я меняю номер расходного ордера
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '422'
			И в поле 'Date' я ввожу текст '30.11.2019  0:00:00'
		И я нажимаю на кнопку 'Post and close'
	И я проверяю проводки документа по регистру "Shipment confirmation schedule"
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.ShipmentConfirmationSchedule"
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                   |'Company'      | 'Order'             | 'Store'    | 'Item key' | 'Delivery date' |
		| '12,000'    | 'Shipment confirmation 422*' |'Main Company' | 'Sales order 422*' | 'Store 02' | 'XS/Blue'  | '30.11.2019'    |
		| '11,000'    | 'Shipment confirmation 422*' |'Main Company' | 'Sales order 422*'| 'Store 02' | '36/18SD'  | '30.11.2019'    |

Сценарий: _170005 проверка фиксирования даты отгрузки в Sales invoice (непрямая схема отгрузки)
	И я создаю Sales invoice
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '422'    |
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		И я нажимаю на кнопку с именем 'FormSelectAll'
		И я нажимаю на кнопку 'Ok'
	И я проверяю заполнение табличной части
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Item key' | 'Store'    | 'Shipment confirmation'       | 'Delivery date' | 'Sales order'        | 'Unit' | 'Q'      |
		| 'Boots' | '36/18SD'  | 'Store 01' | 'Sales order 422*'            | '03.12.2019'    | 'Sales order 422*'   | 'pcs'  | '30,000' |
		| 'Dress' | 'XS/Blue'  | 'Store 02' | 'Shipment confirmation 422*'  | '25.12.2019'    | 'Sales order 422*'   | 'pcs'  | '12,000' |
		| 'Boots' | '36/18SD'  | 'Store 02' | 'Shipment confirmation 422*'  | '21.12.2019'    | 'Sales order 422*'   | 'pcs'  | '11,000' |
	Тогда я меняю номер документа и провожу инвойс
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '422'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '422'
		И я нажимаю на кнопку 'Post'
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post'
	Тогда я проверяю проводки по регистру "Shipment confirmation schedule"
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.ShipmentConfirmationSchedule"
		Тогда таблица "List" не содержит строки:
		| 'Recorder'                   |
		| 'Sales invoice 422*'         |
	И я закрыл все окна клиентского приложения


	# Purchase order
	Сценарий: _170006 проверка заполнение даты выполнения заказа в Purchase order с ордерного + неордерного склада + с одинаковыми строками с разными датами отгрузки (прямая схема отгрузки)
	И я создаю тестовый заказ
		Когда создаю первый тестовый PO для теста по механизму создания на основании
	И я проставляю Delivery date
		И в таблице "ItemList" я перехожу к строке:
			| Item  | Item key |
			| Dress | M/White  |
		И в таблице "ItemList" я активизирую поле с именем "ItemListDeliveryDate"
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '10.12.2019'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| Item  | Item key |
			| Dress | L/Green  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '28.11.2019'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| Item     | Item key |
			| Trousers | 36/Yellow  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '21.12.2019'
	И я добавляю строку с неордерного склада
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 36/18SD  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '3,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '01.12.2019'
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
	И я проверяю отображение даты доставки
		И     таблица "ItemList" содержит строки:
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' |
			| '3 389,83'   | 'Dress'    | '200,00' | 'M/White'   | '20,000' | 'pcs'  | '4 000,00'     | 'Store 02' | '10.12.2019'    |
			| '3 559,32'   | 'Dress'    | '210,00' | 'L/Green'   | '20,000' | 'pcs'  | '4 200,00'     | 'Store 02' | '28.11.2019'    |
			| '5 338,98'   | 'Trousers' | '210,00' | '36/Yellow' | '30,000' | 'pcs'  | '6 300,00'     | 'Store 02' | '21.12.2019'    |
			| '508,47'     | 'Boots'    | '200,00' | '36/18SD'   | '3,000'  | 'pcs'  | '600,00'       | 'Store 01' | '01.12.2019'    |
	Тогда я меняю номер документа и провожу заказ
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '421'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '421'
		И я нажимаю на кнопку 'Post'
	Тогда я проверяю проводки по регистру "GoodsReceiptSchedule"
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsReceiptSchedule"
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Company'      | 'Order'                | 'Store'    | 'Item key'  | 'Delivery date' |
		| '3,000'    | 'Purchase order 421*'| 'Main Company' | 'Purchase order 421*'  | 'Store 01' | '36/18SD'   | '01.12.2019'    |
		| '20,000'   | 'Purchase order 421*'| 'Main Company' | 'Purchase order 421*'  | 'Store 02' | 'M/White'   | '10.12.2019'    |
		| '20,000'   | 'Purchase order 421*'| 'Main Company' | 'Purchase order 421*'  | 'Store 02' | 'L/Green'   | '28.11.2019'    |
		| '30,000'   | 'Purchase order 421*'| 'Main Company' | 'Purchase order 421*'  | 'Store 02' | '36/Yellow' | '21.12.2019'    |

	И я закрыл все окна клиентского приложения


Сценарий: _170007 проверка заполнения даты выполнения заказа в Purchase invoice с неордерного склада при создании на основании + добавление строки которой нет в заказе (прямая схема отгрузки)
	И я создаю на основании Purchase order инвойс
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И в таблице "List" я перехожу к строке:
		| 'Number'   |
		| '421'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
	Тогда я проверяю заполнение даты отгрузки
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |'Store'    | 'Delivery date' |'Unit' | 'Q'      |'Price'  | 'Total amount' |
		| 'Dress'    | 'M/White'   |'Store 02' | '10.12.2019'    |'pcs'  | '20,000' |'200,00' | '4 000,00'     |
		| 'Dress'    | 'L/Green'   |'Store 02' | '28.11.2019'    |'pcs'  | '20,000' |'210,00' | '4 200,00'     |
		| 'Trousers' | '36/Yellow' |'Store 02' | '21.12.2019'    |'pcs'  | '30,000' |'210,00' | '6 300,00'     |
		| 'Boots'    | '36/18SD'   |'Store 01' | '01.12.2019'    |'pcs'  | '3,000'  |'200,00' | '600,00'       |
	И я добавляю строку которой нет в заказе (отгрузка с неордерного склада)
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | M/White  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '09.12.2019'
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
	И я добавляю строку которой нет в заказе (отгрузка с ордерного склада)
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | S/Yellow  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '09.12.2019'
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" в поле 'Price' я ввожу текст '220,00'
	Тогда я меняю номер документа и провожу инвойс
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '421'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '421'
		И я нажимаю на кнопку 'Post'
	Тогда я проверяю проводки по регистру "Goods Receipt Schedule"
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsReceiptSchedule"
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Company'      | 'Order'                 | 'Store'    | 'Item key'  | 'Delivery date' |
		| '2,000'    | 'Purchase invoice 421*' | 'Main Company' | 'Purchase invoice 421*' | 'Store 01' | 'M/White'   | '*'             |
		| '3,000'    | 'Purchase invoice 421*' | 'Main Company' | 'Purchase order 421*'   | 'Store 01' | '36/18SD'   | '*'             |
		| '20,000'   | 'Purchase invoice 421*' | 'Main Company' | 'Purchase order 421*'   | 'Store 02' | 'M/White'   | '10.12.2019'    |
		| '20,000'   | 'Purchase invoice 421*' | 'Main Company' | 'Purchase order 421*'   | 'Store 02' | 'L/Green'   | '28.11.2019'    |
		| '30,000'   | 'Purchase invoice 421*' | 'Main Company' | 'Purchase order 421*'   | 'Store 02' | '36/Yellow' | '21.12.2019'    |
		| '2,000'    | 'Purchase invoice 421*' | 'Main Company' | 'Purchase invoice 421*' | 'Store 01' | 'M/White'   | '09.12.2019'    |
		| '8,000'    | 'Purchase invoice 421*' | 'Main Company' | 'Purchase invoice 421*' | 'Store 02' | 'S/Yellow'  | '09.12.2019'    |
		| '20,000'   | 'Purchase invoice 421*' | 'Main Company' | 'Purchase order 421*'   | 'Store 02' | 'M/White'   | '10.12.2019'    |
		| '20,000'   | 'Purchase invoice 421*' | 'Main Company' | 'Purchase order 421*'   | 'Store 02' | 'L/Green'   | '28.11.2019'    |
		| '30,000'   | 'Purchase invoice 421*' | 'Main Company' | 'Purchase order 421*'   | 'Store 02' | '36/Yellow' | '21.12.2019'    |
	И я закрыл все окна клиентского приложения


Сценарий: _170008 проверка фиксирования фактической даты отгрузки товара в Goods Receipt (прямая схема отгрузки)
	И я создаю Goods Receipt на основании Purchase invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '421'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormDocumentGoodsReceiptGenerateGoodsReceipt"
		И я проверяю заполнение реквизитов
			И     элемент формы с именем "Company" стал равен 'Main Company'
			И     элемент формы с именем "Store" стал равен 'Store 02'
		И я меняю номер расходного ордера
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '421'
			И в поле 'Date' я ввожу текст '30.11.2019  0:00:00'
		И я нажимаю на кнопку 'Post and close'
	И я проверяю проводки документа по регистру "Goods Receipt schedule"
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsReceiptSchedule"
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Company'      | 'Order'                 | 'Store'    | 'Item key'  | 'Delivery date' |
		| '8,000'    | 'Goods receipt 421*' | 'Main Company' | 'Purchase invoice 421*' | 'Store 02' | 'S/Yellow'  | '30.11.2019'    |
		| '20,000'   | 'Goods receipt 421*' | 'Main Company' | 'Purchase invoice 421*' | 'Store 02' | 'M/White'   | '30.11.2019'    |
		| '20,000'   | 'Goods receipt 421*' | 'Main Company' | 'Purchase invoice 421*' | 'Store 02' | 'L/Green'   | '30.11.2019'    |
		| '30,000'   | 'Goods receipt 421*' | 'Main Company' | 'Purchase invoice 421*' | 'Store 02' | '36/Yellow' | '30.11.2019'    |
		И я закрыл все окна клиентского приложения


Сценарий: _170009 проверка фиксирования фактической даты отгрузки в Goods Receipt (непрямая схема отгрузки)
	И я создаю тестовый заказ
		Когда создаю первый тестовый PO для теста по механизму создания на основании
	И я проставляю Delivery date
		И в таблице "ItemList" я перехожу к строке:
			| Item  | Item key |
			| Dress | M/White  |
		И в таблице "ItemList" я активизирую поле с именем "ItemListDeliveryDate"
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '10.12.2019'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| Item  | Item key |
			| Dress | L/Green  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '28.11.2019'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| Item     | Item key |
			| Trousers | 36/Yellow  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '21.12.2019'
	И я добавляю строку с неордерного склада
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 36/18SD  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '3,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Delivery date' я ввожу текст '01.12.2019'
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
	И я проверяю отображение даты доставки
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |'Store'    | 'Delivery date' |'Unit' | 'Q'      |'Price'  | 'Total amount' |
		| 'Dress'    | 'M/White'   |'Store 02' | '10.12.2019'    |'pcs'  | '20,000' |'200,00' | '4 000,00'     |
		| 'Dress'    | 'L/Green'   |'Store 02' | '28.11.2019'    |'pcs'  | '20,000' |'210,00' | '4 200,00'     |
		| 'Trousers' | '36/Yellow' |'Store 02' | '21.12.2019'    |'pcs'  | '30,000' |'210,00' | '6 300,00'     |
		| 'Boots'    | '36/18SD'   |'Store 01' | '01.12.2019'    |'pcs'  | '3,000'  |'200,00' | '600,00'       |
	Тогда я меняю номер документа и провожу заказ
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '422'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '422'
		И я устанавливаю флаг 'Goods receipt before purchase invoice'
		И я нажимаю на кнопку 'Post'
	Тогда я проверяю проводки по регистру "GoodsReceiptSchedule"
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsReceiptSchedule"
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Company'      | 'Order'                | 'Store'    | 'Item key'  | 'Delivery date' |
		| '3,000'    | 'Purchase order 421*'| 'Main Company' | 'Purchase order 421*'  | 'Store 01' | '36/18SD'   | '01.12.2019'    |
		| '20,000'   | 'Purchase order 421*'| 'Main Company' | 'Purchase order 421*'  | 'Store 02' | 'M/White'   | '10.12.2019'    |
		| '20,000'   | 'Purchase order 421*'| 'Main Company' | 'Purchase order 421*'  | 'Store 02' | 'L/Green'   | '28.11.2019'    |
		| '30,000'   | 'Purchase order 421*'| 'Main Company' | 'Purchase order 421*'  | 'Store 02' | '36/Yellow' | '21.12.2019'    |
	И я закрыл все окна клиентского приложения
	И я создаю Goods Receipt на основании Purchase order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number'   |
			| '422'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormDocumentGoodsReceiptGenerateGoodsReceipt"
		И я проверяю заполнение реквизитов
			И     элемент формы с именем "Company" стал равен 'Main Company'
			И     элемент формы с именем "Store" стал равен 'Store 02'
		И я меняю номер расходного ордера
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '422'
			И в поле 'Date' я ввожу текст '30.11.2019  0:00:00'
		И я нажимаю на кнопку 'Post and close'
	И я проверяю проводки документа по регистру "Shipment confirmation schedule"
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsReceiptSchedule"
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'           | 'Company'      | 'Order'               | 'Store'    | 'Item key'  | 'Delivery date' |
		| '20,000'   | 'Goods receipt 422*' | 'Main Company' | 'Purchase order 422*' | 'Store 02' | 'M/White'   | '30.11.2019'    |
		| '20,000'   | 'Goods receipt 422*' | 'Main Company' | 'Purchase order 422*' | 'Store 02' | 'L/Green'   | '30.11.2019'    |
		| '30,000'   | 'Goods receipt 422*' | 'Main Company' | 'Purchase order 422*' | 'Store 02' | '36/Yellow' | '30.11.2019'    |
		И я закрыл все окна клиентского приложения



Сценарий: _170010 проверка фиксирования даты отгрузки в Purchase invoice (непрямая схема отгрузки)
	И я создаю Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '422'    |
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormSelectAll'
		И я нажимаю на кнопку 'Ok'
	И я проверяю заполнение табличной части
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |'Store'    | 'Delivery date' |'Unit' | 'Q'      |'Price'  | 'Total amount' |
		| 'Dress'    | 'M/White'   |'Store 02' | '10.12.2019'    |'pcs'  | '20,000' |'200,00' | '4 000,00'     |
		| 'Dress'    | 'L/Green'   |'Store 02' | '28.11.2019'    |'pcs'  | '20,000' |'210,00' | '4 200,00'     |
		| 'Trousers' | '36/Yellow' |'Store 02' | '21.12.2019'    |'pcs'  | '30,000' |'210,00' | '6 300,00'     |
		| 'Boots'    | '36/18SD'   |'Store 01' | '01.12.2019'    |'pcs'  | '3,000'  |'200,00' | '600,00'       |
	Тогда я меняю номер документа и провожу инвойс
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '422'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '422'
		И я нажимаю на кнопку 'Post'
	Тогда я проверяю проводки по регистру "GoodsReceiptSchedule"
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.GoodsReceiptSchedule"
		Тогда таблица "List" не содержит строки:
		| 'Quantity' | 'Recorder'               | 'Company'      | 'Order'               | 'Store'    | 'Item key' | 'Delivery date' |
		| '3,000'    | 'Purchase invoice 422*'  | 'Main Company' | 'Purchase order 422*' | 'Store 01' | '36/18SD'  | '*'    |
	И Я закрыл все окна клиентского приложения


