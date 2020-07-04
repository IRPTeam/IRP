#language: ru
@tree
@Positive
Функционал: проведение продажи по схеме Shipment confirmation - Sales invoice

Как Разработчик
Я хочу создать схему проведения Shipment confirmation - Sales invoice
Для отгрузки товара клиенту до инвойса (нет цены)

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _0290001 создание документа Shipment confirmation на отгрузку товара клиенту без заказа и инвойса
	* Создание SC на отгрузку Nicoletta со склада Store 02 со своей компании Main company
		* Открытие формы Shipment confirmation
			И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
			И я нажимаю на кнопку с именем 'FormCreate'
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Sales'
		* Заполнение Partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Nicoletta'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'    |
			И в таблице "List" я выбираю текущую строку
		* Добавление товара
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '4,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я активизирую поле "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '8,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '4,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '2 013'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '5 600'
			И я нажимаю на кнопку 'Post and close'
	* Создание SC на отгрузку Nicoletta со склада Store 03 со своей компании Main company
		* Открытие формы Shipment confirmation
			И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
			И я нажимаю на кнопку с именем 'FormCreate'
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Sales'
		* Заполнение Partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Nicoletta'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
		* Добавление товара
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '4,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я активизирую поле "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '8,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '5 601'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '5 601'
			И я нажимаю на кнопку 'Post and close'
	* Создание SC на отгрузку Ferron BP со склада Store 03 на компанию Company Ferron BP со своей компании Main company
		* Открытие формы Shipment confirmation
			И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
			И я нажимаю на кнопку с именем 'FormCreate'
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Sales'
		* Заполнение Partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Ferron BP'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Company Ferron BP' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
		* Добавление товара
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '12,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я активизирую поле "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я активизирую поле "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '4,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '5 602'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '5 602'
			И я нажимаю на кнопку 'Post and close'
	* Создание SC на отгрузку Ferron BP со склада Store 03 на компанию Second Company Ferron BP со своей компании Main company
		* Открытие формы Shipment confirmation
			И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
			И я нажимаю на кнопку с именем 'FormCreate'
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Sales'
		* Заполнение Partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Ferron BP'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| 'Description'              |
				| 'Second Company Ferron BP' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
		* Добавление товара
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '18,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '5 603'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '5 603'
			И я нажимаю на кнопку 'Post and close'
	* Создание SC на отгрузку Ferron BP со склада Store 03 на компанию Company Ferron BP со своей компании Second company
		* Открытие формы Shipment confirmation
			И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
			И я нажимаю на кнопку с именем 'FormCreate'
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Sales'
		* Заполнение Partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Ferron BP'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Company Ferron BP' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
		* Добавление товара
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '12,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я активизирую поле "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '5 604'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '5 604'
			И я нажимаю на кнопку 'Post and close'
	* Проверка создания Shipment confirmation
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Company'      |
		| '5 600'  | 'Main Company' |
		| '5 601'  | 'Main Company' |
		| '5 602'  | 'Main Company' |
		| '5 603'  | 'Main Company' |
		| '5 604'  | 'Second Company' |

Сценарий: _0290002 создание документа Sales invoice на основании созданных Shipment confirmation
	# на основании нескольких Shipment confirmation создается несколько Sales invoice
	* Открытие списка Shipment confirmation
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
	* Выбор нужных SC для создания SI 
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '5 600'  |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И В таблице  "List" я перехожу на одну строку вниз с выделением
	* Создание SI на основании выбранных SC
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		* Проверка создания первого SI
			И я запоминаю количество строк таблицы "ItemList" как "M"
			Если поле с именем "Company" имеет значение "Second Company" тогда
				И     элемент формы с именем "Partner" стал равен 'Ferron BP'
				И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
				И     элемент формы с именем "Store" стал равен 'Store 03'
				Тогда таблица "ItemList" содержит строки:
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 604*' |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 604*' |
				* Заполнение Agreement
					И я нажимаю кнопку выбора у поля "Agreement"
					И в таблице "List" я перехожу к строке:
						| 'Description'                   |
						| 'Basic Agreements, without VAT' |
					И в таблице "List" я выбираю текущую строку
					И я изменяю флаг 'Update filled stores on Store 02'
					И я нажимаю на кнопку 'OK'
				* Проверка расчета таблицы
					Тогда таблица "ItemList" содержит строки:
					| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Price type'              | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Shipment confirmation'        |
					| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000'  | 'Basic Price without VAT' | 'pcs'  | '112,71'     | '593,22'     | '705,93'       | 'Store 03' | 'Shipment confirmation 5 604*' |
					| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '12,000' | 'Basic Price without VAT' | 'pcs'  | '772,88'     | '4 067,76'   | '4 840,64'     | 'Store 03' | 'Shipment confirmation 5 604*' |
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 604'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 604'
			Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда
				И     элемент формы с именем "Partner" стал равен 'Ferron BP'
				И     элемент формы с именем "LegalName" стал равен 'Second Company Ferron BP'
				И     элемент формы с именем "Company" стал равен 'Main Company'
				И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
				| 'Trousers' | '38/Yellow' | '18,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 603*' |
				И я нажимаю кнопку выбора у поля "Agreement"
				И в таблице "List" я перехожу к строке:
					| 'Description'                   |
					| 'Basic Agreements, without VAT' |
				И в таблице "List" я выбираю текущую строку
				И я изменяю флаг 'Update filled stores on Store 02'
				И я нажимаю на кнопку 'OK'
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 600'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 600'
			Если поле с именем "LegalName" имеет значение "Company Nicoletta" тогда
				И     элемент формы с именем "Partner" стал равен 'Nicoletta'
				И     элемент формы с именем "Company" стал равен 'Main Company'
				И     таблица "ItemList" содержит строки:
					| 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Dress'    | 'M/White'   | '4,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Dress'    | 'XS/Blue'   | '2,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 601*' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 601*' |
				И я нажимаю кнопку выбора у поля "Agreement"
				И в таблице "List" я перехожу к строке:
					| 'Description'                   |
					| 'Posting by Standard agreement Customer' |
				И в таблице "List" я выбираю текущую строку
				И я изменяю флаг 'Update filled stores on Store 01'
				И я нажимаю на кнопку 'OK'
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 603'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 603'
			Если переменная "M" имеет значение 3 Тогда
				И     элемент формы с именем "Partner" стал равен 'Ferron BP'
				И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
				И     элемент формы с именем "Company" стал равен 'Main Company'
				И     таблица "ItemList" содержит строки:
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 602*' |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 602*' |
				И я нажимаю кнопку выбора у поля "Agreement"
				И в таблице "List" я перехожу к строке:
					| 'Description'                   |
					| 'Basic Agreements, without VAT' |
				И в таблице "List" я выбираю текущую строку
				И я изменяю флаг 'Update filled stores on Store 02'
				И я нажимаю на кнопку 'OK'
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 602'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 602'
			И я нажимаю на кнопку 'Post and close'
		* Проверка создания второго Si
			И я запоминаю количество строк таблицы "ItemList" как "M"
			Если поле с именем "Company" имеет значение "Second Company" тогда
				И     элемент формы с именем "Partner" стал равен 'Ferron BP'
				И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
				И     элемент формы с именем "Store" стал равен 'Store 03'
				Тогда таблица "ItemList" содержит строки:
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 604*' |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 604*' |
				* Заполнение Agreement
					И я нажимаю кнопку выбора у поля "Agreement"
					И в таблице "List" я перехожу к строке:
						| 'Description'                   |
						| 'Basic Agreements, without VAT' |
					И в таблице "List" я выбираю текущую строку
					И я изменяю флаг 'Update filled stores on Store 02'
					И я нажимаю на кнопку 'OK'
				* Проверка расчета таблицы
					Тогда таблица "ItemList" содержит строки:
					| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Price type'              | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Shipment confirmation'        |
					| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000'  | 'Basic Price without VAT' | 'pcs'  | '112,71'     | '593,22'     | '705,93'       | 'Store 03' | 'Shipment confirmation 5 604*' |
					| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '12,000' | 'Basic Price without VAT' | 'pcs'  | '772,88'     | '4 067,76'   | '4 840,64'     | 'Store 03' | 'Shipment confirmation 5 604*' |
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 604'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 604'
			Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда
				И     элемент формы с именем "Partner" стал равен 'Ferron BP'
				И     элемент формы с именем "LegalName" стал равен 'Second Company Ferron BP'
				И     элемент формы с именем "Company" стал равен 'Main Company'
				И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
				| 'Trousers' | '38/Yellow' | '18,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 603*' |
				И я нажимаю кнопку выбора у поля "Agreement"
				И в таблице "List" я перехожу к строке:
					| 'Description'                   |
					| 'Basic Agreements, without VAT' |
				И в таблице "List" я выбираю текущую строку
				И я изменяю флаг 'Update filled stores on Store 02'
				И я нажимаю на кнопку 'OK'
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 600'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 600'
			Если поле с именем "LegalName" имеет значение "Company Nicoletta" тогда
				И     элемент формы с именем "Partner" стал равен 'Nicoletta'
				И     элемент формы с именем "Company" стал равен 'Main Company'
				И     таблица "ItemList" содержит строки:
					| 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Dress'    | 'M/White'   | '4,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Dress'    | 'XS/Blue'   | '2,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 601*' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 601*' |
				И я нажимаю кнопку выбора у поля "Agreement"
				И в таблице "List" я перехожу к строке:
					| 'Description'                   |
					| 'Posting by Standard agreement Customer' |
				И в таблице "List" я выбираю текущую строку
				И я изменяю флаг 'Update filled stores on Store 01'
				И я нажимаю на кнопку 'OK'
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 603'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 603'
			Если переменная "M" имеет значение 3 Тогда
				И     элемент формы с именем "Partner" стал равен 'Ferron BP'
				И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
				И     элемент формы с именем "Company" стал равен 'Main Company'
				И     таблица "ItemList" содержит строки:
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 602*' |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 602*' |
				И я нажимаю кнопку выбора у поля "Agreement"
				И в таблице "List" я перехожу к строке:
					| 'Description'                   |
					| 'Basic Agreements, without VAT' |
				И в таблице "List" я выбираю текущую строку
				И я изменяю флаг 'Update filled stores on Store 02'
				И я нажимаю на кнопку 'OK'
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 602'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 602'
			И я нажимаю на кнопку 'Post and close'
		* Проверка создания третьего Si
			И я запоминаю количество строк таблицы "ItemList" как "M"
			Если поле с именем "Company" имеет значение "Second Company" тогда
				И     элемент формы с именем "Partner" стал равен 'Ferron BP'
				И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
				И     элемент формы с именем "Store" стал равен 'Store 03'
				Тогда таблица "ItemList" содержит строки:
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 604*' |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 604*' |
				* Заполнение Agreement
					И я нажимаю кнопку выбора у поля "Agreement"
					И в таблице "List" я перехожу к строке:
						| 'Description'                   |
						| 'Basic Agreements, without VAT' |
					И в таблице "List" я выбираю текущую строку
					И я изменяю флаг 'Update filled stores on Store 02'
					И я нажимаю на кнопку 'OK'
				* Проверка расчета таблицы
					Тогда таблица "ItemList" содержит строки:
					| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Price type'              | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Shipment confirmation'        |
					| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000'  | 'Basic Price without VAT' | 'pcs'  | '112,71'     | '593,22'     | '705,93'       | 'Store 03' | 'Shipment confirmation 5 604*' |
					| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '12,000' | 'Basic Price without VAT' | 'pcs'  | '772,88'     | '4 067,76'   | '4 840,64'     | 'Store 03' | 'Shipment confirmation 5 604*' |
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 604'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 604'
			Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда
				И     элемент формы с именем "Partner" стал равен 'Ferron BP'
				И     элемент формы с именем "LegalName" стал равен 'Second Company Ferron BP'
				И     элемент формы с именем "Company" стал равен 'Main Company'
				И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
				| 'Trousers' | '38/Yellow' | '18,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 603*' |
				И я нажимаю кнопку выбора у поля "Agreement"
				И в таблице "List" я перехожу к строке:
					| 'Description'                   |
					| 'Basic Agreements, without VAT' |
				И в таблице "List" я выбираю текущую строку
				И я изменяю флаг 'Update filled stores on Store 02'
				И я нажимаю на кнопку 'OK'
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 600'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 600'
			Если поле с именем "LegalName" имеет значение "Company Nicoletta" тогда
				И     элемент формы с именем "Partner" стал равен 'Nicoletta'
				И     элемент формы с именем "Company" стал равен 'Main Company'
				И     таблица "ItemList" содержит строки:
					| 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Dress'    | 'M/White'   | '4,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Dress'    | 'XS/Blue'   | '2,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 601*' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 601*' |
				И я нажимаю кнопку выбора у поля "Agreement"
				И в таблице "List" я перехожу к строке:
					| 'Description'                   |
					| 'Posting by Standard agreement Customer' |
				И в таблице "List" я выбираю текущую строку
				И я изменяю флаг 'Update filled stores on Store 01'
				И я нажимаю на кнопку 'OK'
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 603'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 603'
			Если переменная "M" имеет значение 3 Тогда
				И     элемент формы с именем "Partner" стал равен 'Ferron BP'
				И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
				И     элемент формы с именем "Company" стал равен 'Main Company'
				И     таблица "ItemList" содержит строки:
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 602*' |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 602*' |
				И я нажимаю кнопку выбора у поля "Agreement"
				И в таблице "List" я перехожу к строке:
					| 'Description'                   |
					| 'Basic Agreements, without VAT' |
				И в таблице "List" я выбираю текущую строку
				И я изменяю флаг 'Update filled stores on Store 02'
				И я нажимаю на кнопку 'OK'
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 602'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 602'
			И я нажимаю на кнопку 'Post and close'
		* Проверка создания четвертого Si
			И я запоминаю количество строк таблицы "ItemList" как "M"
			Если поле с именем "Company" имеет значение "Second Company" тогда
				И     элемент формы с именем "Partner" стал равен 'Ferron BP'
				И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
				И     элемент формы с именем "Store" стал равен 'Store 03'
				Тогда таблица "ItemList" содержит строки:
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 604*' |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 604*' |
				* Заполнение Agreement
					И я нажимаю кнопку выбора у поля "Agreement"
					И в таблице "List" я перехожу к строке:
						| 'Description'                   |
						| 'Basic Agreements, without VAT' |
					И в таблице "List" я выбираю текущую строку
					И я изменяю флаг 'Update filled stores on Store 02'
					И я нажимаю на кнопку 'OK'
				* Проверка расчета таблицы
					Тогда таблица "ItemList" содержит строки:
					| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Price type'              | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Shipment confirmation'        |
					| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000'  | 'Basic Price without VAT' | 'pcs'  | '112,71'     | '593,22'     | '705,93'       | 'Store 03' | 'Shipment confirmation 5 604*' |
					| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '12,000' | 'Basic Price without VAT' | 'pcs'  | '772,88'     | '4 067,76'   | '4 840,64'     | 'Store 03' | 'Shipment confirmation 5 604*' |
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 604'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 604'
			Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда
				И     элемент формы с именем "Partner" стал равен 'Ferron BP'
				И     элемент формы с именем "LegalName" стал равен 'Second Company Ferron BP'
				И     элемент формы с именем "Company" стал равен 'Main Company'
				И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
				| 'Trousers' | '38/Yellow' | '18,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 603*' |
				И я нажимаю кнопку выбора у поля "Agreement"
				И в таблице "List" я перехожу к строке:
					| 'Description'                   |
					| 'Basic Agreements, without VAT' |
				И в таблице "List" я выбираю текущую строку
				И я изменяю флаг 'Update filled stores on Store 02'
				И я нажимаю на кнопку 'OK'
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 600'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 600'
			Если поле с именем "LegalName" имеет значение "Company Nicoletta" тогда
				И     элемент формы с именем "Partner" стал равен 'Nicoletta'
				И     элемент формы с именем "Company" стал равен 'Main Company'
				И     таблица "ItemList" содержит строки:
					| 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Dress'    | 'M/White'   | '4,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Dress'    | 'XS/Blue'   | '2,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 02' | 'Shipment confirmation 5 600*' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 601*' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 601*' |
				И я нажимаю кнопку выбора у поля "Agreement"
				И в таблице "List" я перехожу к строке:
					| 'Description'                   |
					| 'Posting by Standard agreement Customer' |
				И в таблице "List" я выбираю текущую строку
				И я изменяю флаг 'Update filled stores on Store 01'
				И я нажимаю на кнопку 'OK'
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 603'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 603'
			Если переменная "M" имеет значение 3 Тогда
				И     элемент формы с именем "Partner" стал равен 'Ferron BP'
				И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
				И     элемент формы с именем "Company" стал равен 'Main Company'
				И     таблица "ItemList" содержит строки:
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 602*' |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | 'Shipment confirmation 5 602*' |
				И я нажимаю кнопку выбора у поля "Agreement"
				И в таблице "List" я перехожу к строке:
					| 'Description'                   |
					| 'Basic Agreements, without VAT' |
				И в таблице "List" я выбираю текущую строку
				И я изменяю флаг 'Update filled stores on Store 02'
				И я нажимаю на кнопку 'OK'
				И я перехожу к закладке "Other"
				И в поле 'Number' я ввожу текст '5 602'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '5 602'
			И я нажимаю на кнопку 'Post and close'

		







