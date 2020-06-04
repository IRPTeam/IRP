#language: ru
@tree
@Positive
Функционал: создание заказа поставщику на основании заказа клиента

Как Разработчик
Я хочу создать заказ поставщику на основании заказа клиента
Чтобы реализовать схему закупки под конкретную продажу

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _029200 создание тестовых данных
	* Создание Sales order 501
		* Открытие формы создания заказа
			И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение шапки
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Lomaniti'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Company Lomaniti' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Agreements, without VAT' |
			И в таблице "List" я выбираю текущую строку
		* Заполнение таблицы товаров
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Item list"
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" я завершаю редактирование строки
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в таблице "ItemList" я завершаю редактирование строки
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '501'
			И я устанавливаю флаг 'Shipment confirmations before sales invoice'
			И я нажимаю на кнопку 'Post and close'
	* Создание Sales order 502
		* Открытие формы создания заказа
			И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение шапки
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Lomaniti'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Company Lomaniti' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Заполнение таблицы товаров
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Item list"
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '11,000'
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" я завершаю редактирование строки
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в таблице "ItemList" я завершаю редактирование строки
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '502'
			И я нажимаю на кнопку 'Post and close'
	* Создание Sales order 503
		* Открытие формы создания заказа
			И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение шапки
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Lomaniti'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Company Lomaniti' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Agreements, without VAT' |
			И в таблице "List" я выбираю текущую строку
		* Заполнение таблицы товаров
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Item list"
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '12,000'
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '7,000'
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" я завершаю редактирование строки
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в таблице "ItemList" я завершаю редактирование строки
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '503'
			И я устанавливаю флаг 'Shipment confirmations before sales invoice'
			И я нажимаю на кнопку 'Post and close'
	* Создание Sales order 504
		* Открытие формы создания заказа
			И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение шапки
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Lomaniti'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Company Lomaniti' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Agreements, without VAT' |
			И в таблице "List" я выбираю текущую строку
		* Заполнение таблицы товаров
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Item list"
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '7,000'
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" я завершаю редактирование строки
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в таблице "ItemList" я завершаю редактирование строки
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '504'
			И я устанавливаю флаг 'Shipment confirmations before sales invoice'
			И я нажимаю на кнопку 'Post and close'
	* Создание Sales order 505
		* Открытие формы создания заказа
			И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение шапки
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Lomaniti'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Company Lomaniti' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Заполнение таблицы товаров
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Item list"
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '31,000'
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shirt'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '40,000'
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" я завершаю редактирование строки
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в таблице "ItemList" я завершаю редактирование строки
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '505'
			И я нажимаю на кнопку 'Post and close'



# Непрямая схема отгрузки Sales order - Purchase order - Goods reciept - Purchase invoice - Shipment confirmation - Sales invoice
Сценарий: _029201 создание Purchase order на основании Sales order (непрямая схема поставки)
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	Тогда я меняю метод обеспечения по строкам и добавляю новую строку
		И в таблице "ItemList" я перехожу к строке:
			| Item  |
			| Dress |
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| Item  |
			| Boots |
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
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я меняю номер документа на 455
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Shipment confirmations before sales invoice'
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '455'
	* Проведение заказа
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post and close'
	* Проверка проводок заказа
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
		| Number |
		| 455    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales order 455*'                           | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'          | 'Item key'              | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '1'         | 'Main Company'     | '36/18SD'               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'         | 'Main Company'     | 'XS/Blue'               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Main Company'     | '38/Yellow'             | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'            | 'Item key'              | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 01'         | '36/18SD'               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'         | 'XS/Blue'               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'         | '38/Yellow'             | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order procurement"'              | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'          | 'Order'                 | 'Store'     | 'Item key'  | 'Row key' | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company'     | 'Sales order 455*'      | 'Store 01'  | 'XS/Blue'   | '*'       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company'     | 'Sales order 455*'      | 'Store 01'  | '38/Yellow' | '*'       | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'            | 'Item key'              | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '1'         | 'Store 01'         | '36/18SD'               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Shipment orders"'                | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Order'            | 'Shipment confirmation' | 'Item key'  | 'Row key'   | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Sales order 455*' | 'Sales order 455*'      | '36/18SD'   | '*'         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'       | ''                      | ''          | ''          | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'          | 'Sales order'           | 'Currency'  | 'Item key'  | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '119,86'    | 'Main Company'     | 'Sales order 455*'      | 'USD'       | '36/18SD'   | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '1'         | '700'       | 'Main Company'     | 'Sales order 455*'      | 'TRY'       | '36/18SD'   | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '1'         | '700'       | 'Main Company'     | 'Sales order 455*'      | 'TRY'       | '36/18SD'   | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '700'       | 'Main Company'     | 'Sales order 455*'      | 'TRY'       | '36/18SD'   | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '5'         | '445,21'    | 'Main Company'     | 'Sales order 455*'      | 'USD'       | 'XS/Blue'   | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 600'     | 'Main Company'     | 'Sales order 455*'      | 'TRY'       | 'XS/Blue'   | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 600'     | 'Main Company'     | 'Sales order 455*'      | 'TRY'       | 'XS/Blue'   | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 600'     | 'Main Company'     | 'Sales order 455*'      | 'TRY'       | 'XS/Blue'   | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '684,93'    | 'Main Company'     | 'Sales order 455*'      | 'USD'       | '38/Yellow' | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '4 000'     | 'Main Company'     | 'Sales order 455*'      | 'TRY'       | '38/Yellow' | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '4 000'     | 'Main Company'     | 'Sales order 455*'      | 'TRY'       | '38/Yellow' | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '4 000'     | 'Main Company'     | 'Sales order 455*'      | 'TRY'       | '38/Yellow' | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'            | 'Order'                 | 'Item key'  | 'Row key'   | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 01'         | 'Sales order 455*'      | '36/18SD'   | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'         | 'Sales order 455*'      | 'XS/Blue'   | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'         | 'Sales order 455*'      | '38/Yellow' | '*'         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'            | 'Item key'              | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '1'         | 'Store 01'         | '36/18SD'               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''                 | ''                      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''          | ''          | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'          | 'Order'                 | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company'     | 'Sales order 455*'      | 'Store 01'  | '36/18SD'   | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company'     | 'Sales order 455*'      | 'Store 01'  | 'XS/Blue'   | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company'     | 'Sales order 455*'      | 'Store 01'  | '38/Yellow' | '*'       | '*'                        | ''                     |
		| ''                                           | 'Expense'     | '*'         | '1'         | 'Main Company'     | 'Sales order 455*'      | 'Store 01'  | '36/18SD'   | '*'       | '*'                        | ''                     |

		И Я закрыл все окна клиентского приложения
	И я создаю ещё один заказ клиента для заказа поставщику
		Когда создаю заказ на Ferron BP Basic Agreements, TRY (Dress -10 и Trousers - 5)
		И я меняю склад на ордерный
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02    |
			И в таблице "List" я выбираю текущую строку
			Тогда открылось окно 'Update item list info'
			И     элемент формы с именем "Stores" стал равен 'Yes'
			И я нажимаю на кнопку 'OK'
	Тогда я меняю метод обеспечения по строкам и добавляю новую строку
			И в таблице "ItemList" я перехожу к строке:
				| Item  |
				| Dress |
			И в таблице "ItemList" я активизирую поле "Procurement method"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| Item  | 
				| Trousers |
			И в таблице "ItemList" я активизирую поле "Procurement method"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
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
			И в таблице "ItemList" я активизирую поле "Procurement method"
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И я перехожу к следующему реквизиту
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
			И в таблице "ItemList" я завершаю редактирование строки
	И я меняю номер документа на 456
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг 'Shipment confirmations before sales invoice'
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '456'
	И я провожу заказ
			И я перехожу к закладке "Item list"
			И в таблице "ItemList" я нажимаю на кнопку '% Offers'
			Тогда открылось окно 'Pickup special offers'
			И в таблице "Offers" я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку 'Post and close'
	Тогда я проверяю проводки заказа
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
		| Number |
		| 456    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales order 456*'                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 02'     | '36/Yellow'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'XS/Blue'          | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | '38/Yellow'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order procurement"'              | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | 'Sales order 456*' | 'Store 02'  | '36/Yellow' | '*'       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 456*' | 'Store 02'  | 'XS/Blue'   | '*'       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 456*' | 'Store 02'  | '38/Yellow' | '*'       | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'      | 'Currency'  | 'Item key'  | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '5'         | '342,47'    | 'Main Company' | 'Sales order 456*' | 'USD'       | '36/Yellow' | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 000'     | 'Main Company' | 'Sales order 456*' | 'TRY'       | '36/Yellow' | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 000'     | 'Main Company' | 'Sales order 456*' | 'TRY'       | '36/Yellow' | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 000'     | 'Main Company' | 'Sales order 456*' | 'TRY'       | '36/Yellow' | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '684,93'    | 'Main Company' | 'Sales order 456*' | 'USD'       | '38/Yellow' | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '890,41'    | 'Main Company' | 'Sales order 456*' | 'USD'       | 'XS/Blue'   | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '4 000'     | 'Main Company' | 'Sales order 456*' | 'TRY'       | '38/Yellow' | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '4 000'     | 'Main Company' | 'Sales order 456*' | 'TRY'       | '38/Yellow' | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '4 000'     | 'Main Company' | 'Sales order 456*' | 'TRY'       | '38/Yellow' | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '5 200'     | 'Main Company' | 'Sales order 456*' | 'TRY'       | 'XS/Blue'   | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '5 200'     | 'Main Company' | 'Sales order 456*' | 'TRY'       | 'XS/Blue'   | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '5 200'     | 'Main Company' | 'Sales order 456*' | 'TRY'       | 'XS/Blue'   | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'            | 'Item key'  | 'Row key'   | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 02'     | 'Sales order 456*' | '36/Yellow' | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'Sales order 456*' | 'XS/Blue'   | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'Sales order 456*' | '38/Yellow' | '*'         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | 'Sales order 456*' | 'Store 02'  | '36/Yellow' | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 456*' | 'Store 02'  | 'XS/Blue'   | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 456*' | 'Store 02'  | '38/Yellow' | '*'       | '*'                        | ''                     |
		И Я закрыл все окна клиентского приложения
	Тогда на основании созданных заказов я создаю один Purchase order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
		| Number | Partner  |
		| 455    | Lomaniti |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseOrderGeneratePurchaseOrder'
	И я проверяю заполнение табличной части Purchase order
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Store'    | 'Unit' | 'Q'      | 'Purchase basis'   |
		| 'Dress'    | 'XS/Blue'   | 'Store 01' | 'pcs'  | '5,000'  | 'Sales order 455*' |
		| 'Trousers' | '38/Yellow' | 'Store 01' | 'pcs'  | '10,000' | 'Sales order 455*' |
		| 'Dress'    | 'XS/Blue'   | 'Store 02' | 'pcs'  | '10,000' | 'Sales order 456*' |
		| 'Trousers' | '36/Yellow' | 'Store 02' | 'pcs'  | '5,000'  | 'Sales order 456*' |
		| 'Trousers' | '38/Yellow' | 'Store 02' | 'pcs'  | '10,000' | 'Sales order 456*' |
	И я заполняю данные по поставщику и цены
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Company Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
			| Description        |
			| Vendor Ferron, TRY |
		И в таблице "List" я выбираю текущую строку
		# сообщение по изменению цен
		И я снимаю флаг 'Update filled price types on Vendor price, TRY'
		И я снимаю флаг 'Update filled prices.'
		И я нажимаю на кнопку 'OK'
		# сообщение по изменению цен
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Store'    |
			| 'Dress' | 'XS/Blue'  | 'Store 01' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'   | 'Store'    |
			| 'Trousers' | '38/Yellow'  | 'Store 01' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '180,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Store'    |
			| 'Dress' | 'XS/Blue'  | 'Store 02' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'   | 'Store'    |
			| 'Trousers' | '36/Yellow'  | 'Store 02' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '180,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'   | 'Store'    |
			| 'Trousers' | '38/Yellow'  | 'Store 02' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '180,00'
		И в таблице "ItemList" я завершаю редактирование строки
	И я устанавливаю номер документа 456
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Goods receipt before purchase invoice'
		И в поле 'Number' я ввожу текст '456'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '456'
	И я нажимаю на кнопку 'Post and close'
	Тогда я проверяю проводки Purchase order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И в таблице "List" я перехожу к строке:
		| Number |
		| 456    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase order 456*'                   | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Document registrations records'        | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Inventory balance"'         | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'             | 'Item key'            | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Main Company'        | 'XS/Blue'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Main Company'        | '38/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Order procurement"'         | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'             | 'Order'               | 'Store'     | 'Item key'  | 'Row key' | ''              |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Main Company'        | 'Sales order 455*'    | 'Store 01'  | 'XS/Blue'   | '*'       | ''              |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Main Company'        | 'Sales order 456*'    | 'Store 02'  | '36/Yellow' | '*'       | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company'        | 'Sales order 455*'    | 'Store 01'  | '38/Yellow' | '*'       | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company'        | 'Sales order 456*'    | 'Store 02'  | 'XS/Blue'   | '*'       | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company'        | 'Sales order 456*'    | 'Store 02'  | '38/Yellow' | '*'       | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'               | 'Receipt basis'       | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'            | 'Purchase order 456*' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | 'Purchase order 456*' | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | 'Purchase order 456*' | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'               | 'Item key'            | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 01'            | 'XS/Blue'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 01'            | '38/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Store 01'            | 'XS/Blue'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'            | '38/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Receipt orders"'            | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Order'               | 'Goods receipt'       | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Purchase order 456*' | 'Purchase order 456*' | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Purchase order 456*' | 'Purchase order 456*' | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | 'Attributes'    |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'             | 'Order'               | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Main Company'        | 'Purchase order 456*' | 'Store 01'  | 'XS/Blue'   | '*'       | '*'             |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Main Company'        | 'Purchase order 456*' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Main Company'        | 'Purchase order 456*' | 'Store 01'  | '38/Yellow' | '*'       | '*'             |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Main Company'        | 'Purchase order 456*' | 'Store 02'  | 'XS/Blue'   | '*'       | '*'             |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Main Company'        | 'Purchase order 456*' | 'Store 02'  | '38/Yellow' | '*'       | '*'             |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Main Company'        | 'Purchase order 456*' | 'Store 01'  | 'XS/Blue'   | '*'       | '*'             |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company'        | 'Purchase order 456*' | 'Store 01'  | '38/Yellow' | '*'       | '*'             |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Order balance"'             | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'               | 'Order'               | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 01'            | 'Purchase order 456*' | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'            | 'Purchase order 456*' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 01'            | 'Purchase order 456*' | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | 'Purchase order 456*' | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | 'Purchase order 456*' | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'               | 'Item key'            | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 01'            | 'XS/Blue'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 01'            | '38/Yellow'           | ''          | ''          | ''        | ''              |
		И Я закрыл все окна клиентского приложения

Сценарий: _029202 создание Goods reciept на основании Purchase order созданного по заказу клиента (непрямая схема поставки)
	И я создаю Goods reciept
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 456    |
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	Тогда я проверяю заполнение табличной части
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Sales order'      | 'Store'    | 'Receipt basis'       |
			| 'Dress'    | '10,000'   | 'XS/Blue'   | 'pcs'  | 'Sales order 456*' | 'Store 02' | 'Purchase order 456*' |
			| 'Trousers' | '5,000'    | '36/Yellow' | 'pcs'  | 'Sales order 456*' | 'Store 02' | 'Purchase order 456*' |
			| 'Trousers' | '10,000'   | '38/Yellow' | 'pcs'  | 'Sales order 456*' | 'Store 02' | 'Purchase order 456*' |
	И я устанавливаю номер документа 456
		И в поле 'Number' я ввожу текст '456'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '456'
		И я нажимаю на кнопку 'Post and close'
	Тогда я проверяю движения документа
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 456    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Goods receipt 456*'                    | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Document registrations records'        | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Inventory balance"'         | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'             | 'Item key'            | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Main Company'        | '36/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Main Company'        | 'XS/Blue'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Main Company'        | '38/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit outgoing"' | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'               | 'Shipment basis'      | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'            | 'Sales order 456*'    | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | 'Sales order 456*'    | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | 'Sales order 456*'    | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'               | 'Receipt basis'       | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Store 02'            | 'Purchase order 456*' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'            | 'Purchase order 456*' | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'            | 'Purchase order 456*' | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'               | 'Item key'            | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'            | '36/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | 'XS/Blue'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | '38/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Store 02'            | '36/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'            | 'XS/Blue'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'            | '38/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Receipt orders"'            | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Order'               | 'Goods receipt'       | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Purchase order 456*' | 'Goods receipt 456*'  | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Purchase order 456*' | 'Goods receipt 456*'  | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Purchase order 456*' | 'Goods receipt 456*'  | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | 'Attributes'    |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'             | 'Order'               | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Main Company'        | 'Purchase order 456*' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company'        | 'Purchase order 456*' | 'Store 02'  | 'XS/Blue'   | '*'       | '*'             |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company'        | 'Purchase order 456*' | 'Store 02'  | '38/Yellow' | '*'       | '*'             |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'               | 'Item key'            | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'            | '36/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | 'XS/Blue'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | '38/Yellow'           | ''          | ''          | ''        | ''              |


	И Я закрыл все окна клиентского приложения

Сценарий: _029203 проверка проводок в случае если в Purchase order будет дополнительная строка которой нет в Sales order (непрямая схема поставки)
	И я помечаю Goods reciept 456 пометкой на удаление
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 456    |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И Я закрыл все окна клиентского приложения
	И я добавляю в Purchase order 456 ещё одну строку не по заказу
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 456    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Q' я ввожу текст '50'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я проверяю движения документа
			И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
			И в таблице "List" я перехожу к строке:
			| Number |
			| 456    |
			И я нажимаю на кнопку 'Registrations report'
			Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Purchase order 456*'                   | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| 'Document registrations records'        | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| 'Register  "Inventory balance"'         | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'                                   | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Company'                                      | 'Item key'            | ''          | ''          | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Main Company'                                 | 'XS/Blue'             | ''          | ''          | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Main Company'                                 | '38/Yellow'           | ''          | ''          | ''        | ''              |
			| ''                                      | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| 'Register  "Order procurement"'         | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'                                   | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Company'                                      | 'Order'               | 'Store'     | 'Item key'  | 'Row key' | ''              |
			| ''                                      | 'Expense'     | '*'      | '5'         | 'Main Company'                                 | 'Sales order 455*'    | 'Store 01'  | 'XS/Blue'   | '*'       | ''              |
			| ''                                      | 'Expense'     | '*'      | '5'         | 'Main Company'                                 | 'Sales order 456*'    | 'Store 02'  | '36/Yellow' | '*'       | ''              |
			| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company'                                 | 'Sales order 455*'    | 'Store 01'  | '38/Yellow' | '*'       | ''              |
			| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company'                                 | 'Sales order 456*'    | 'Store 02'  | 'XS/Blue'   | '*'       | ''              |
			| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company'                                 | 'Sales order 456*'    | 'Store 02'  | '38/Yellow' | '*'       | ''              |
			| ''                                      | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'                                   | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'                                        | 'Receipt basis'       | 'Item key'  | 'Row key'   | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'                                     | 'Purchase order 456*' | '36/Yellow' | '*'         | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'                                     | 'Purchase order 456*' | 'XS/Blue'   | '*'         | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'                                     | 'Purchase order 456*' | '38/Yellow' | '*'         | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'                                     | 'Purchase order 456*' | 'M/White'   | '*'         | ''        | ''              |
			| ''                                      | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'                                   | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'                                        | 'Item key'            | ''          | ''          | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 01'                                     | 'XS/Blue'             | ''          | ''          | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 01'                                     | '38/Yellow'           | ''          | ''          | ''        | ''              |
			| ''                                      | 'Expense'     | '*'      | '5'         | 'Store 01'                                     | 'XS/Blue'             | ''          | ''          | ''        | ''              |
			| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'                                     | '38/Yellow'           | ''          | ''          | ''        | ''              |
			| ''                                      | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| 'Register  "Receipt orders"'            | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'                                   | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Order'                                        | 'Goods receipt'       | 'Item key'  | 'Row key'   | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Purchase order 456*'                          | 'Purchase order 456*' | 'XS/Blue'   | '*'         | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Purchase order 456*'                          | 'Purchase order 456*' | '38/Yellow' | '*'         | ''        | ''              |
			| ''                                      | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'                                   | ''                    | ''          | ''          | ''        | 'Attributes'    |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Company'                                      | 'Order'               | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Main Company'                                 | 'Purchase order 456*' | 'Store 01'  | 'XS/Blue'   | '*'       | '*'             |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Main Company'                                 | 'Purchase order 456*' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Main Company'                                 | 'Purchase order 456*' | 'Store 01'  | '38/Yellow' | '*'       | '*'             |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Main Company'                                 | 'Purchase order 456*' | 'Store 02'  | 'XS/Blue'   | '*'       | '*'             |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Main Company'                                 | 'Purchase order 456*' | 'Store 02'  | '38/Yellow' | '*'       | '*'             |
			| ''                                      | 'Receipt'     | '*'      | '50'        | 'Main Company'                                 | 'Purchase order 456*' | 'Store 02'  | 'M/White'   | '*'       | '*'             |
			| ''                                      | 'Expense'     | '*'      | '5'         | 'Main Company'                                 | 'Purchase order 456*' | 'Store 01'  | 'XS/Blue'   | '*'       | '*'             |
			| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company'                                 | 'Purchase order 456*' | 'Store 01'  | '38/Yellow' | '*'       | '*'             |
			| ''                                      | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| 'Register  "Order balance"'             | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'                                   | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'                                        | 'Order'               | 'Item key'  | 'Row key'   | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 01'                                     | 'Purchase order 456*' | 'XS/Blue'   | '*'         | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'                                     | 'Purchase order 456*' | '36/Yellow' | '*'         | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 01'                                     | 'Purchase order 456*' | '38/Yellow' | '*'         | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'                                     | 'Purchase order 456*' | 'XS/Blue'   | '*'         | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'                                     | 'Purchase order 456*' | '38/Yellow' | '*'         | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'                                     | 'Purchase order 456*' | 'M/White'   | '*'         | ''        | ''              |
			| ''                                      | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''                                             | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'                                   | ''                    | ''          | ''          | ''        | ''              |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'                                        | 'Item key'            | ''          | ''          | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 01'                                     | 'XS/Blue'             | ''          | ''          | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 01'                                     | '38/Yellow'           | ''          | ''          | ''        | ''              |

	Тогда я создаю GoodsReceipt 457
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 456   |
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	Тогда я проверяю заполнение табличной части Goods receipt
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Sales order'      | 'Store'    | 'Receipt basis'       |
			| 'Dress'    | '10,000'   | 'XS/Blue'   | 'pcs'  | 'Sales order 456*' | 'Store 02' | 'Purchase order 456*' |
			| 'Dress'    | '50,000'   | 'M/White'   | 'pcs'  | ''                 | 'Store 02' | 'Purchase order 456*' |
			| 'Trousers' | '5,000'    | '36/Yellow' | 'pcs'  | 'Sales order 456*' | 'Store 02' | 'Purchase order 456*' |
			| 'Trousers' | '10,000'   | '38/Yellow' | 'pcs'  | 'Sales order 456*' | 'Store 02' | 'Purchase order 456*' |
	И я устанавливаю номер документа 457
		И в поле 'Number' я ввожу текст '457'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '457'
		И я нажимаю на кнопку 'Post and close'
	Тогда я проверяю движения документа
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 457    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Goods receipt 457*'                    | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Document registrations records'        | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Inventory balance"'         | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'             | 'Item key'            | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Main Company'        | '36/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Main Company'        | 'XS/Blue'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Main Company'        | '38/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Main Company'        | 'M/White'             | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit outgoing"' | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'               | 'Shipment basis'      | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'            | 'Sales order 456*'    | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | 'Sales order 456*'    | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | 'Sales order 456*'    | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'               | 'Receipt basis'       | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Store 02'            | 'Purchase order 456*' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'            | 'Purchase order 456*' | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'            | 'Purchase order 456*' | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 02'            | 'Purchase order 456*' | 'M/White'   | '*'         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'               | 'Item key'            | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'            | '36/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | 'XS/Blue'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | '38/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'            | 'M/White'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Store 02'            | '36/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'            | 'XS/Blue'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'            | '38/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Receipt orders"'            | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Order'               | 'Goods receipt'       | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Purchase order 456*' | 'Goods receipt 457*'  | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Purchase order 456*' | 'Goods receipt 457*'  | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Purchase order 456*' | 'Goods receipt 457*'  | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Purchase order 456*' | 'Goods receipt 457*'  | 'M/White'   | '*'         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | 'Attributes'    |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'             | 'Order'               | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Main Company'        | 'Purchase order 456*' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company'        | 'Purchase order 456*' | 'Store 02'  | 'XS/Blue'   | '*'       | '*'             |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company'        | 'Purchase order 456*' | 'Store 02'  | '38/Yellow' | '*'       | '*'             |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Main Company'        | 'Purchase order 456*' | 'Store 02'  | 'M/White'   | '*'       | '*'             |
		| ''                                      | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''                    | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'          | ''                    | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'               | 'Item key'            | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'            | '36/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | 'XS/Blue'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'            | '38/Yellow'           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'            | 'M/White'             | ''          | ''          | ''        | ''              |
	И Я закрыл все окна клиентского приложения

Сценарий: _029204 создание Purchase invoice на основании Purchase order связаного с заказом клиента (непрямая схема поставки)
	И я создаю Purchase invoice на основании Purchase order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 456   |
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormSelectAll'
		И я нажимаю на кнопку 'OK'
	Тогда я проверяю заполнение табличной части
		И     таблица "ItemList" содержит строки:
		| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      |'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Purchase order'                             | 'Goods receipt'      | 'Sales order'      |
		| '762,71'     | 'Trousers' | '180,00' | '36/Yellow' | '5,000'  |'137,29'     | 'pcs'  | '900,00'       | 'Store 02' | 'Purchase order 456*'                        | 'Goods receipt 457*' | 'Sales order 456*' |
		| '1 694,92'   | 'Dress'    | '200,00' | 'XS/Blue'   | '10,000' |'305,08'     | 'pcs'  | '2 000,00'     | 'Store 02' | 'Purchase order 456*'                        | 'Goods receipt 457*' | 'Sales order 456*' |
		| '8 898,31'   | 'Dress'    | '210,00' | 'M/White'   | '50,000' |'1 601,69'   | 'pcs'  | '10 500,00'    | 'Store 02' | 'Purchase order 456*'                        | 'Goods receipt 457*' | ''                 |
		| '1 525,42'   | 'Trousers' | '180,00' | '38/Yellow' | '10,000' |'274,58'     | 'pcs'  | '1 800,00'     | 'Store 02' | 'Purchase order 456*'                        | 'Goods receipt 457*' | 'Sales order 456*' |
		| '1 525,42'   | 'Trousers' | '180,00' | '38/Yellow' | '10,000' |'274,58'     | 'pcs'  | '1 800,00'     | 'Store 01' | 'Purchase order 456*'                        | ''                   | 'Sales order 455*' |
		| '847,46'     | 'Dress'    | '200,00' | 'XS/Blue'   | '5,000'  |'152,54'     | 'pcs'  | '1 000,00'     | 'Store 01' | 'Purchase order 456*'                        | ''                   | 'Sales order 455*' |
	И я устанавливаю номер документа 457
		И в поле 'Number' я ввожу текст '457'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '457'
		И я нажимаю на кнопку 'Post and close'
	Тогда я проверяю движения документа
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 457    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase invoice 457*'                | ''            | ''          | ''              | ''                    | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''              | ''                    | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Purchase turnovers"'       | ''            | ''          | ''              | ''                    | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''                    | 'Dimensions'            | ''                      | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | 'Quantity'  | 'Amount'        | 'Net amount'          | 'Company'               | 'Purchase invoice'      | 'Currency'          | 'Item key'           | 'Row key'                 | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | '*'           | '5'         | '154,11'        | '130,6'               | 'Main Company'          | 'Purchase invoice 457*' | 'USD'               | '36/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '5'         | '171,23'        | '145,11'              | 'Main Company'          | 'Purchase invoice 457*' | 'USD'               | 'XS/Blue'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '5'         | '900'           | '762,71'              | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | '36/Yellow'          | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '5'         | '900'           | '762,71'              | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | '36/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '5'         | '900'           | '762,71'              | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | '36/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '5'         | '1 000'         | '847,46'              | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | 'XS/Blue'            | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '5'         | '1 000'         | '847,46'              | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | 'XS/Blue'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '5'         | '1 000'         | '847,46'              | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | 'XS/Blue'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '10'        | '308,22'        | '261,2'               | 'Main Company'          | 'Purchase invoice 457*' | 'USD'               | '38/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '10'        | '308,22'        | '261,2'               | 'Main Company'          | 'Purchase invoice 457*' | 'USD'               | '38/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '10'        | '342,47'        | '290,23'              | 'Main Company'          | 'Purchase invoice 457*' | 'USD'               | 'XS/Blue'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '10'        | '1 800'         | '1 525,42'            | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | '38/Yellow'          | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '10'        | '1 800'         | '1 525,42'            | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | '38/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '10'        | '1 800'         | '1 525,42'            | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | '38/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '10'        | '1 800'         | '1 525,42'            | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | '38/Yellow'          | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '10'        | '1 800'         | '1 525,42'            | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | '38/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '10'        | '1 800'         | '1 525,42'            | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | '38/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '10'        | '2 000'         | '1 694,92'            | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | 'XS/Blue'            | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '10'        | '2 000'         | '1 694,92'            | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | 'XS/Blue'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '10'        | '2 000'         | '1 694,92'            | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | 'XS/Blue'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '50'        | '1 797,95'      | '1 523,68'            | 'Main Company'          | 'Purchase invoice 457*' | 'USD'               | 'M/White'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '50'        | '10 500'        | '8 898,31'            | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | 'M/White'            | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '50'        | '10 500'        | '8 898,31'            | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | 'M/White'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '50'        | '10 500'        | '8 898,31'            | 'Main Company'          | 'Purchase invoice 457*' | 'TRY'               | 'M/White'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''                    | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'          | ''            | ''          | ''              | ''                    | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''                    | 'Dimensions'            | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | 'Attributes'           |
		| ''                                     | ''            | 'Amount'    | 'Manual amount' | 'Net amount'          | 'Document'              | 'Tax'                   | 'Analytics'         | 'Tax rate'           | 'Include to total amount' | 'Row key'                  | 'Currency'             | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                     | '*'           | '23,51'     | '23,51'         | '130,6'               | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '26,12'     | '26,12'         | '145,11'              | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '47,02'     | '47,02'         | '261,2'               | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '47,02'     | '47,02'         | '261,2'               | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '52,24'     | '52,24'         | '290,23'              | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '137,29'    | '137,29'        | '762,71'              | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '137,29'    | '137,29'        | '762,71'              | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '137,29'    | '137,29'        | '762,71'              | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '152,54'    | '152,54'        | '847,46'              | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '152,54'    | '152,54'        | '847,46'              | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '152,54'    | '152,54'        | '847,46'              | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '274,26'    | '274,26'        | '1 523,68'            | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '274,58'    | '274,58'        | '1 525,42'            | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '274,58'    | '274,58'        | '1 525,42'            | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '274,58'    | '274,58'        | '1 525,42'            | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '274,58'    | '274,58'        | '1 525,42'            | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '274,58'    | '274,58'        | '1 525,42'            | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '274,58'    | '274,58'        | '1 525,42'            | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '305,08'    | '305,08'        | '1 694,92'            | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '305,08'    | '305,08'        | '1 694,92'            | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '305,08'    | '305,08'        | '1 694,92'            | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '1 601,69'  | '1 601,69'      | '8 898,31'            | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                     | '*'           | '1 601,69'  | '1 601,69'      | '8 898,31'            | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '1 601,69'  | '1 601,69'      | '8 898,31'            | 'Purchase invoice 457*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | ''            | ''          | ''              | ''                    | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Accounts statement"'                 | ''                    | ''                    | ''                    | ''                                             | ''                                               | ''                                               | ''                                     | ''                   | ''                                     | ''                                               | ''                     | ''                         | ''                     |
		| ''                                               | 'Record type'         | 'Period'              | 'Resources'           | ''                                             | ''                                               | ''                                               | 'Dimensions'                           | ''                   | ''                                     | ''                                               | ''                     | ''                         | ''                     |
		| ''                                               | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP'                               | 'Advance from customers'                         | 'Transaction AR'                                 | 'Company'                              | 'Partner'            | 'Legal name'                           | 'Basis document'                                 | 'Currency'             | ''                         | ''                     |
		| ''                                               | 'Receipt'             | '*' | ''                    | '18 000'                                       | ''                                               | ''                                               | 'Main Company'                         | 'Ferron BP'          | 'Company Ferron BP'                    | 'Purchase invoice 457*' | 'TRY'                  | ''                         | ''                     |
		| ''                                               | ''                    | ''                    | ''                    | ''                                             | ''                                               | ''                                               | ''                                     | ''                   | ''                                     | ''                                               | ''                     | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''              | ''                    | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'          | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'             | 'Legal name'            | 'Currency'              | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '18 000'        | 'Main Company'        | 'Company Ferron BP'     | 'TRY'                   | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''                    | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Receipt orders"'           | ''            | ''          | ''              | ''                    | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'          | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Order'               | 'Goods receipt'         | 'Item key'              | 'Row key'           | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '5'             | 'Purchase order 456*' | 'Goods receipt 457*'    | '36/Yellow'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '10'            | 'Purchase order 456*' | 'Goods receipt 457*'    | 'XS/Blue'               | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '10'            | 'Purchase order 456*' | 'Goods receipt 457*'    | '38/Yellow'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '50'            | 'Purchase order 456*' | 'Goods receipt 457*'    | 'M/White'               | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''                    | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''              | ''                    | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'          | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'             | 'Basis document'        | 'Partner'               | 'Legal name'        | 'Agreement'          | 'Currency'                | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '3 082,19'      | 'Main Company'        | 'Purchase invoice 457*' | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'USD'                     | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '18 000'        | 'Main Company'        | 'Purchase invoice 457*' | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '18 000'        | 'Main Company'        | 'Purchase invoice 457*' | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '18 000'        | 'Main Company'        | 'Purchase invoice 457*' | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''                    | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Order balance"'            | ''            | ''          | ''              | ''                    | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'          | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'               | 'Order'                 | 'Item key'              | 'Row key'           | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '5'             | 'Store 02'            | 'Purchase order 456*'   | '36/Yellow'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '10'            | 'Store 02'            | 'Purchase order 456*'   | 'XS/Blue'               | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '10'            | 'Store 02'            | 'Purchase order 456*'   | '38/Yellow'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '50'            | 'Store 02'            | 'Purchase order 456*'   | 'M/White'               | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		И Я закрыл все окна клиентского приложения

Сценарий: _029205 создание Shipment confirmation на основании Sales order под заказ поставщику (непрямая схема отгрузки, склад ордерный)
	И я создаю Shipment confirmation на основании Sales order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 456   |
		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
	Тогда я проверяю заполнение табличной части
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Shipment basis'   |
		| 'Dress'    | '10,000'   | 'XS/Blue'   | 'pcs'  | 'Store 02' | 'Sales order 456*' |
		| 'Trousers' | '5,000'    | '36/Yellow' | 'pcs'  | 'Store 02' | 'Sales order 456*' |
		| 'Trousers' | '10,000'   | '38/Yellow' | 'pcs'  | 'Store 02' | 'Sales order 456*' |
	И я меняю номер документа и провожу его
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '456'
		И я нажимаю на кнопку 'Post'
	Тогда я проверяю движения документа
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Shipment confirmation 456*'                 | ''            | ''       | ''          | ''                 | ''                           | ''          | ''          | ''        | ''              |
		| 'Document registrations records'             | ''            | ''       | ''          | ''                 | ''                           | ''          | ''          | ''        | ''              |
		| 'Register  "Inventory balance"'              | ''            | ''       | ''          | ''                 | ''                           | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'       | ''                           | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Company'          | 'Item key'                   | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '5'         | 'Main Company'     | '36/Yellow'                  | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company'     | 'XS/Blue'                    | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company'     | '38/Yellow'                  | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''                 | ''                           | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit outgoing"'      | ''            | ''       | ''          | ''                 | ''                           | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'       | ''                           | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'            | 'Shipment basis'             | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '5'         | 'Store 02'         | 'Sales order 456*'           | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'         | 'Sales order 456*'           | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'         | 'Sales order 456*'           | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''                 | ''                           | ''          | ''          | ''        | ''              |
		| 'Register  "Shipment orders"'                | ''            | ''       | ''          | ''                 | ''                           | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'       | ''                           | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Order'            | 'Shipment confirmation'      | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                           | 'Receipt'     | '*'      | '5'         | 'Sales order 456*' | 'Shipment confirmation 456*' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                           | 'Receipt'     | '*'      | '10'        | 'Sales order 456*' | 'Shipment confirmation 456*' | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                           | 'Receipt'     | '*'      | '10'        | 'Sales order 456*' | 'Shipment confirmation 456*' | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''                 | ''                           | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'                  | ''            | ''       | ''          | ''                 | ''                           | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'       | ''                           | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'            | 'Item key'                   | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '5'         | 'Store 02'         | '36/Yellow'                  | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'         | 'XS/Blue'                    | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'         | '38/Yellow'                  | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''                 | ''                           | ''          | ''          | ''        | ''              |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''       | ''          | ''                 | ''                           | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'       | ''                           | ''          | ''          | ''        | 'Attributes'    |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Company'          | 'Order'                      | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                           | 'Expense'     | '*'      | '5'         | 'Main Company'     | 'Sales order 456*'           | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company'     | 'Sales order 456*'           | 'Store 02'  | 'XS/Blue'   | '*'       | '*'             |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company'     | 'Sales order 456*'           | 'Store 02'  | '38/Yellow' | '*'       | '*'             |
		И Я закрыл все окна клиентского приложения

Сценарий: _029206 создание Sales invoice на основании Sales order под заказ поставщику (непрямая схема отгрузки, склад ордерный)
	И я создаю Sales invoice на основании Sales order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 456   |
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		И я нажимаю на кнопку с именем 'FormSelectAll'
		И я нажимаю на кнопку 'OK'
	Тогда я проверяю заполнение табличной части
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Q'      |'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
		| 'Dress'    | '520,00' | 'XS/Blue'   | '10,000' |'793,22'     | 'pcs'  | '4 406,78'   | '5 200,00'     | 'Store 02' |
		| 'Trousers' | '400,00' | '36/Yellow' | '5,000'  |'305,08'     | 'pcs'  | '1 694,92'   | '2 000,00'     | 'Store 02' |
		| 'Trousers' | '400,00' | '38/Yellow' | '10,000' |'610,17'     | 'pcs'  | '3 389,83'   | '4 000,00'     | 'Store 02' |
	И я устанавливаю номер документа 456
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '456'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '456'
	И я провожу инвойс
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		Тогда открылось окно 'Pickup special offers'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post and close'
	Тогда я проверяю проводки Sales invoice
		И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
		И в таблице "List" я перехожу к строке:
		| Number |
		| 456    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Sales invoice 456*'                   | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Partner AR transactions"'  | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'       | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | 'Attributes'               | ''                         | ''                     |
			| ''                                     | ''            | ''          | 'Amount'        | 'Company'          | 'Basis document'             | 'Partner'      | 'Legal name'         | 'Agreement'           | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation'     | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'         | '1 917,81'      | 'Main Company'     | 'Sales invoice 456*'         | 'Ferron BP'    | 'Company Ferron BP'  | 'Basic Agreements, TRY'  | 'USD'                      | 'Reporting currency'       | 'No'                       | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'         | '11 200'        | 'Main Company'     | 'Sales invoice 456*'         | 'Ferron BP'    | 'Company Ferron BP'  | 'Basic Agreements, TRY'  | 'TRY'                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'         | '11 200'        | 'Main Company'     | 'Sales invoice 456*'         | 'Ferron BP'    | 'Company Ferron BP'  | 'Basic Agreements, TRY'  | 'TRY'                      | 'Local currency'           | 'No'                       | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'         | '11 200'        | 'Main Company'     | 'Sales invoice 456*'         | 'Ferron BP'    | 'Company Ferron BP'  | 'Basic Agreements, TRY'  | 'TRY'                      | 'TRY'                      | 'No'                       | ''                         | ''                     |
			| ''                                     | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Order reservation"'        | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'       | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | ''            | ''          | 'Quantity'      | 'Store'            | 'Item key'                   | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'         | '5'             | 'Store 02'         | '36/Yellow'                  | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'         | '10'            | 'Store 02'         | 'XS/Blue'                    | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'         | '10'            | 'Store 02'         | '38/Yellow'                  | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Taxes turnovers"'          | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Period'      | 'Resources' | ''              | ''                 | 'Dimensions'                 | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | 'Attributes'           |
			| ''                                     | ''            | 'Amount'    | 'Manual amount' | 'Net amount'       | 'Document'                   | 'Tax'          | 'Analytics'          | 'Tax rate'            | 'Include to total amount'  | 'Row key'                  | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
			| ''                                     | '*'           | '52,24'     | '52,24'         | '290,23'           | 'Sales invoice 456*'         | 'VAT'          | ''                   | '18%'                 | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
			| ''                                     | '*'           | '104,48'    | '104,48'        | '580,45'           | 'Sales invoice 456*'         | 'VAT'          | ''                   | '18%'                 | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
			| ''                                     | '*'           | '135,83'    | '135,83'        | '754,59'           | 'Sales invoice 456*'         | 'VAT'          | ''                   | '18%'                 | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
			| ''                                     | '*'           | '305,08'    | '305,08'        | '1 694,92'         | 'Sales invoice 456*'         | 'VAT'          | ''                   | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | '*'           | '305,08'    | '305,08'        | '1 694,92'         | 'Sales invoice 456*'         | 'VAT'          | ''                   | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
			| ''                                     | '*'           | '305,08'    | '305,08'        | '1 694,92'         | 'Sales invoice 456*'         | 'VAT'          | ''                   | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
			| ''                                     | '*'           | '610,17'    | '610,17'        | '3 389,83'         | 'Sales invoice 456*'         | 'VAT'          | ''                   | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | '*'           | '610,17'    | '610,17'        | '3 389,83'         | 'Sales invoice 456*'         | 'VAT'          | ''                   | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
			| ''                                     | '*'           | '610,17'    | '610,17'        | '3 389,83'         | 'Sales invoice 456*'         | 'VAT'          | ''                   | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
			| ''                                     | '*'           | '793,22'    | '793,22'        | '4 406,78'         | 'Sales invoice 456*'         | 'VAT'          | ''                   | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | '*'           | '793,22'    | '793,22'        | '4 406,78'         | 'Sales invoice 456*'         | 'VAT'          | ''                   | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
			| ''                                     | '*'           | '793,22'    | '793,22'        | '4 406,78'         | 'Sales invoice 456*'         | 'VAT'          | ''                   | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
			| ''                                     | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Accounts statement"'              | ''                    | ''                    | ''                    | ''                                          | ''                                                    | ''               | ''                                            | ''                      | ''                         | ''                                            | ''                         | ''                         | ''                     |
			| ''                                            | 'Record type'         | 'Period'              | 'Resources'           | ''                                          | ''                                                    | ''               | 'Dimensions'                                  | ''                      | ''                         | ''                                            | ''                         | ''                         | ''                     |
			| ''                                            | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP'                            | 'Advance from customers'                              | 'Transaction AR' | 'Company'                                     | 'Partner'               | 'Legal name'               | 'Basis document'                              | 'Currency'                 | ''                         | ''                     |
			| ''                                            | 'Receipt'             | '*' | ''                    | ''                                          | ''                                                    | '11 200'         | 'Main Company'                                | 'Ferron BP'             | 'Company Ferron BP'        | 'Sales invoice 456*' | 'TRY'                      | ''                         | ''                     |
			| ''                                            | ''                    | ''                    | ''                    | ''                                          | ''                                                    | ''               | ''                                            | ''                      | ''                         | ''                                            | ''                         | ''                         | ''                     |
			| 'Register  "Sales turnovers"'          | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Period'      | 'Resources' | ''              | ''                 | ''                           | 'Dimensions'   | ''                   | ''                    | ''                         | ''                         | ''                         | 'Attributes'               | ''                     |
			| ''                                     | ''            | 'Quantity'  | 'Amount'        | 'Net amount'       | 'Offers amount'              | 'Company'      | 'Sales invoice'      | 'Currency'            | 'Item key'                 | 'Row key'                  | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                     | '*'           | '5'         | '342,47'        | '290,23'           | ''                           | 'Main Company' | 'Sales invoice 456*' | 'USD'                 | '36/Yellow'                | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                     | '*'           | '5'         | '2 000'         | '1 694,92'         | ''                           | 'Main Company' | 'Sales invoice 456*' | 'TRY'                 | '36/Yellow'                | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                     | '*'           | '5'         | '2 000'         | '1 694,92'         | ''                           | 'Main Company' | 'Sales invoice 456*' | 'TRY'                 | '36/Yellow'                | '*'                        | 'Local currency'           | 'No'                       | ''                     |
			| ''                                     | '*'           | '5'         | '2 000'         | '1 694,92'         | ''                           | 'Main Company' | 'Sales invoice 456*' | 'TRY'                 | '36/Yellow'                | '*'                        | 'TRY'                      | 'No'                       | ''                     |
			| ''                                     | '*'           | '10'        | '684,93'        | '580,45'           | ''                           | 'Main Company' | 'Sales invoice 456*' | 'USD'                 | '38/Yellow'                | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                     | '*'           | '10'        | '890,41'        | '754,59'           | ''                           | 'Main Company' | 'Sales invoice 456*' | 'USD'                 | 'XS/Blue'                  | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                     | '*'           | '10'        | '4 000'         | '3 389,83'         | ''                           | 'Main Company' | 'Sales invoice 456*' | 'TRY'                 | '38/Yellow'                | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                     | '*'           | '10'        | '4 000'         | '3 389,83'         | ''                           | 'Main Company' | 'Sales invoice 456*' | 'TRY'                 | '38/Yellow'                | '*'                        | 'Local currency'           | 'No'                       | ''                     |
			| ''                                     | '*'           | '10'        | '4 000'         | '3 389,83'         | ''                           | 'Main Company' | 'Sales invoice 456*' | 'TRY'                 | '38/Yellow'                | '*'                        | 'TRY'                      | 'No'                       | ''                     |
			| ''                                     | '*'           | '10'        | '5 200'         | '4 406,78'         | ''                           | 'Main Company' | 'Sales invoice 456*' | 'TRY'                 | 'XS/Blue'                  | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                     | '*'           | '10'        | '5 200'         | '4 406,78'         | ''                           | 'Main Company' | 'Sales invoice 456*' | 'TRY'                 | 'XS/Blue'                  | '*'                        | 'Local currency'           | 'No'                       | ''                     |
			| ''                                     | '*'           | '10'        | '5 200'         | '4 406,78'         | ''                           | 'Main Company' | 'Sales invoice 456*' | 'TRY'                 | 'XS/Blue'                  | '*'                        | 'TRY'                      | 'No'                       | ''                     |
			| ''                                     | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Shipment orders"'          | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'       | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | ''            | ''          | 'Quantity'      | 'Order'            | 'Shipment confirmation'      | 'Item key'     | 'Row key'            | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'         | '5'             | 'Sales order 456*' | 'Shipment confirmation 456*' | '36/Yellow'    | '*'                  | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'         | '10'            | 'Sales order 456*' | 'Shipment confirmation 456*' | 'XS/Blue'      | '*'                  | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'         | '10'            | 'Sales order 456*' | 'Shipment confirmation 456*' | '38/Yellow'    | '*'                  | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'       | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | ''            | ''          | 'Amount'        | 'Company'          | 'Legal name'                 | 'Currency'     | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'         | '11 200'        | 'Main Company'     | 'Company Ferron BP'          | 'TRY'          | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Revenues turnovers"'       | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Period'      | 'Resources' | 'Dimensions'    | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | 'Attributes'               | ''                         | ''                         | ''                     |
			| ''                                     | ''            | 'Amount'    | 'Company'       | 'Business unit'    | 'Revenue type'               | 'Item key'     | 'Currency'           | 'Additional analytic' | 'Currency movement type'   | 'Deferred calculation'     | ''                         | ''                         | ''                     |
			| ''                                     | '*'           | '290,23'    | 'Main Company'  | ''                 | ''                           | '36/Yellow'    | 'USD'                | ''                    | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                     | '*'           | '580,45'    | 'Main Company'  | ''                 | ''                           | '38/Yellow'    | 'USD'                | ''                    | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                     | '*'           | '754,59'    | 'Main Company'  | ''                 | ''                           | 'XS/Blue'      | 'USD'                | ''                    | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                     | '*'           | '1 694,92'  | 'Main Company'  | ''                 | ''                           | '36/Yellow'    | 'TRY'                | ''                    | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                     | '*'           | '1 694,92'  | 'Main Company'  | ''                 | ''                           | '36/Yellow'    | 'TRY'                | ''                    | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                     | '*'           | '1 694,92'  | 'Main Company'  | ''                 | ''                           | '36/Yellow'    | 'TRY'                | ''                    | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                     | '*'           | '3 389,83'  | 'Main Company'  | ''                 | ''                           | '38/Yellow'    | 'TRY'                | ''                    | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                     | '*'           | '3 389,83'  | 'Main Company'  | ''                 | ''                           | '38/Yellow'    | 'TRY'                | ''                    | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                     | '*'           | '3 389,83'  | 'Main Company'  | ''                 | ''                           | '38/Yellow'    | 'TRY'                | ''                    | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                     | '*'           | '4 406,78'  | 'Main Company'  | ''                 | ''                           | 'XS/Blue'      | 'TRY'                | ''                    | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                     | '*'           | '4 406,78'  | 'Main Company'  | ''                 | ''                           | 'XS/Blue'      | 'TRY'                | ''                    | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                     | '*'           | '4 406,78'  | 'Main Company'  | ''                 | ''                           | 'XS/Blue'      | 'TRY'                | ''                    | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                     | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Order balance"'            | ''            | ''          | ''              | ''                 | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'       | ''                           | ''             | ''                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | ''            | ''          | 'Quantity'      | 'Store'            | 'Order'                      | 'Item key'     | 'Row key'            | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'         | '5'             | 'Store 02'         | 'Sales order 456*'           | '36/Yellow'    | '*'                  | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'         | '10'            | 'Store 02'         | 'Sales order 456*'           | 'XS/Blue'      | '*'                  | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'         | '10'            | 'Store 02'         | 'Sales order 456*'           | '38/Yellow'    | '*'                  | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		И Я закрыл все окна клиентского приложения


# Прямая схема отгрузки Sales order - Purchase order - Purchase invoice- Goods reciept - Sales invoice - Shipment confirmation 

Сценарий: _029207 создание Purchase order на основании Sales order (прямая схема поставки, услуги в заказе клиента + товары)
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	Тогда я меняю метод обеспечения по строкам и добавляю новую строку
		И в таблице "ItemList" я перехожу к строке:
			| Item  |
			| Dress |
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| Item  |
			| Boots |
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
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
	Тогда я добавляю услугу
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Service    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item     | Item key  |
			| Service  | Rent |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
	И я меняю номер документа на 460
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '460'
	И я провожу заказ
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		Тогда открылось окно 'Pickup special offers'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post and close'
	Тогда я проверяю проводки заказа
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
		| Number |
		| 460    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales order 460*'                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 01'     | '36/18SD'          | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | 'XS/Blue'          | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'     | '38/Yellow'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order procurement"'              | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | 'Sales order 460*' | 'Store 01'  | 'XS/Blue'   | '*'       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 460*' | 'Store 01'  | '38/Yellow' | '*'       | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '1'         | 'Store 01'     | '36/18SD'          | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'      | 'Currency'  | 'Item key'  | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '119,86'    | 'Main Company' | 'Sales order 460*' | 'USD'       | '36/18SD'   | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '1'         | '700'       | 'Main Company' | 'Sales order 460*' | 'TRY'       | '36/18SD'   | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '1'         | '700'       | 'Main Company' | 'Sales order 460*' | 'TRY'       | '36/18SD'   | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '700'       | 'Main Company' | 'Sales order 460*' | 'TRY'       | '36/18SD'   | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '5'         | '445,21'    | 'Main Company' | 'Sales order 460*' | 'USD'       | 'XS/Blue'   | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 600'     | 'Main Company' | 'Sales order 460*' | 'TRY'       | 'XS/Blue'   | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 600'     | 'Main Company' | 'Sales order 460*' | 'TRY'       | 'XS/Blue'   | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 600'     | 'Main Company' | 'Sales order 460*' | 'TRY'       | 'XS/Blue'   | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '342,47'    | 'Main Company' | 'Sales order 460*' | 'USD'       | 'Rent'      | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '684,93'    | 'Main Company' | 'Sales order 460*' | 'USD'       | '38/Yellow' | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '2 000'     | 'Main Company' | 'Sales order 460*' | 'TRY'       | 'Rent'      | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '2 000'     | 'Main Company' | 'Sales order 460*' | 'TRY'       | 'Rent'      | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '2 000'     | 'Main Company' | 'Sales order 460*' | 'TRY'       | 'Rent'      | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '4 000'     | 'Main Company' | 'Sales order 460*' | 'TRY'       | '38/Yellow' | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '4 000'     | 'Main Company' | 'Sales order 460*' | 'TRY'       | '38/Yellow' | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '4 000'     | 'Main Company' | 'Sales order 460*' | 'TRY'       | '38/Yellow' | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'            | 'Item key'  | 'Row key'   | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 01'     | 'Sales order 460*' | '36/18SD'   | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | 'Sales order 460*' | 'XS/Blue'   | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'     | 'Sales order 460*' | '38/Yellow' | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'     | 'Sales order 460*' | 'Rent'      | '*'         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company' | 'Sales order 460*' | 'Store 01'  | '36/18SD'   | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | 'Sales order 460*' | 'Store 01'  | 'XS/Blue'   | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 460*' | 'Store 01'  | '38/Yellow' | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 460*' | 'Store 01'  | 'Rent'      | '*'       | '*'                        | ''                     |
		И Я закрыл все окна клиентского приложения
	И я создаю ещё один заказ клиента для заказа поставщику
		Когда создаю заказ на Ferron BP Basic Agreements, TRY (Dress -10 и Trousers - 5)
		И я меняю склад на ордерный
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02    |
			И в таблице "List" я выбираю текущую строку
			# Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
	Тогда я меняю метод обеспечения по строкам и добавляю новую строку
			И в таблице "ItemList" я перехожу к строке:
				| Item  |
				| Dress |
			И в таблице "ItemList" я активизирую поле "Procurement method"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| Item  | 
				| Trousers |
			И в таблице "ItemList" я активизирую поле "Procurement method"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
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
			И в таблице "ItemList" я активизирую поле "Procurement method"
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И я перехожу к следующему реквизиту
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
			И в таблице "ItemList" я завершаю редактирование строки
		Тогда я добавляю услугу
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Service    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| Item     | Item key  |
				| Service  | Rent |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '300,00'
	И я меняю номер документа на 461
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '461'
	И я провожу заказ
			И я перехожу к закладке "Item list"
			И в таблице "ItemList" я нажимаю на кнопку '% Offers'
			Тогда открылось окно 'Pickup special offers'
			И в таблице "Offers" я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку 'Post and close'
	Тогда я проверяю проводки заказа
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
		| Number |
		| 461    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales order 461*'                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 02'     | '36/Yellow'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'XS/Blue'          | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | '38/Yellow'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order procurement"'              | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | 'Sales order 461*' | 'Store 02'  | '36/Yellow' | '*'       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 461*' | 'Store 02'  | 'XS/Blue'   | '*'       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 461*' | 'Store 02'  | '38/Yellow' | '*'       | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'      | 'Currency'  | 'Item key'  | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '51,37'     | 'Main Company' | 'Sales order 461*' | 'USD'       | 'Rent'      | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '1'         | '300'       | 'Main Company' | 'Sales order 461*' | 'TRY'       | 'Rent'      | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '1'         | '300'       | 'Main Company' | 'Sales order 461*' | 'TRY'       | 'Rent'      | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '300'       | 'Main Company' | 'Sales order 461*' | 'TRY'       | 'Rent'      | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '5'         | '342,47'    | 'Main Company' | 'Sales order 461*' | 'USD'       | '36/Yellow' | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 000'     | 'Main Company' | 'Sales order 461*' | 'TRY'       | '36/Yellow' | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 000'     | 'Main Company' | 'Sales order 461*' | 'TRY'       | '36/Yellow' | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 000'     | 'Main Company' | 'Sales order 461*' | 'TRY'       | '36/Yellow' | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '684,93'    | 'Main Company' | 'Sales order 461*' | 'USD'       | '38/Yellow' | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '890,41'    | 'Main Company' | 'Sales order 461*' | 'USD'       | 'XS/Blue'   | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '4 000'     | 'Main Company' | 'Sales order 461*' | 'TRY'       | '38/Yellow' | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '4 000'     | 'Main Company' | 'Sales order 461*' | 'TRY'       | '38/Yellow' | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '4 000'     | 'Main Company' | 'Sales order 461*' | 'TRY'       | '38/Yellow' | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '5 200'     | 'Main Company' | 'Sales order 461*' | 'TRY'       | 'XS/Blue'   | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '5 200'     | 'Main Company' | 'Sales order 461*' | 'TRY'       | 'XS/Blue'   | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '5 200'     | 'Main Company' | 'Sales order 461*' | 'TRY'       | 'XS/Blue'   | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'            | 'Item key'  | 'Row key'   | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 02'     | 'Sales order 461*' | 'Rent'      | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 02'     | 'Sales order 461*' | '36/Yellow' | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'Sales order 461*' | 'XS/Blue'   | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'Sales order 461*' | '38/Yellow' | '*'         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                 | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company' | 'Sales order 461*' | 'Store 02'  | 'Rent'      | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | 'Sales order 461*' | 'Store 02'  | '36/Yellow' | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 461*' | 'Store 02'  | 'XS/Blue'   | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 461*' | 'Store 02'  | '38/Yellow' | '*'       | '*'                        | ''                     |

		И Я закрыл все окна клиентского приложения
	Тогда на основании созданных заказов я создаю один Purchase order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
		| Number | Partner  |
		| 460    | Lomaniti |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseOrderGeneratePurchaseOrder'
	И я проверяю заполнение табличной части Purchase order
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Store'    | 'Unit' | 'Q'      | 'Purchase basis'   |
		| 'Dress'    | 'XS/Blue'   | 'Store 01' | 'pcs'  | '5,000'  | 'Sales order 460*' |
		| 'Trousers' | '38/Yellow' | 'Store 01' | 'pcs'  | '10,000' | 'Sales order 460*' |
		| 'Dress'    | 'XS/Blue'   | 'Store 02' | 'pcs'  | '10,000' | 'Sales order 461*' |
		| 'Trousers' | '36/Yellow' | 'Store 02' | 'pcs'  | '5,000'  | 'Sales order 461*' |
		| 'Trousers' | '38/Yellow' | 'Store 02' | 'pcs'  | '10,000' | 'Sales order 461*' |
	И я заполняю данные по поставщику и цены
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Company Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
			| Description        |
			| Vendor Ferron, TRY |
		И в таблице "List" я выбираю текущую строку
		# сообщение по ценам
		И я изменяю флаг 'Update filled price types on Vendor price, TRY'
		И я изменяю флаг 'Update filled prices.'
		И я нажимаю на кнопку 'OK'
		# сообщение по ценам
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Store'    |
			| 'Dress' | 'XS/Blue'  | 'Store 01' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'   | 'Store'    |
			| 'Trousers' | '38/Yellow'  | 'Store 01' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '180,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Store'    |
			| 'Dress' | 'XS/Blue'  | 'Store 02' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'   | 'Store'    |
			| 'Trousers' | '36/Yellow'  | 'Store 02' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '180,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'   | 'Store'    |
			| 'Trousers' | '38/Yellow'  | 'Store 02' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '180,00'
		И в таблице "ItemList" я завершаю редактирование строки
	И я устанавливаю номер документа 456
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '460'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '460'
	И я нажимаю на кнопку 'Post and close'
	Тогда я проверяю проводки Purchase order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И в таблице "List" я перехожу к строке:
		| Number |
		| 460    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase order 460*'                | ''            | ''       | ''          | ''             | ''                    | ''          | ''          | ''        | ''              |
		| 'Document registrations records'     | ''            | ''       | ''          | ''             | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Order procurement"'      | ''            | ''       | ''          | ''             | ''                    | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''          | ''          | ''        | ''              |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'               | 'Store'     | 'Item key'  | 'Row key' | ''              |
		| ''                                   | 'Expense'     | '*'      | '5'         | 'Main Company' | 'Sales order 460*'    | 'Store 01'  | 'XS/Blue'   | '*'       | ''              |
		| ''                                   | 'Expense'     | '*'      | '5'         | 'Main Company' | 'Sales order 461*'    | 'Store 02'  | '36/Yellow' | '*'       | ''              |
		| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | 'Sales order 460*'    | 'Store 01'  | '38/Yellow' | '*'       | ''              |
		| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | 'Sales order 461*'    | 'Store 02'  | 'XS/Blue'   | '*'       | ''              |
		| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | 'Sales order 461*'    | 'Store 02'  | '38/Yellow' | '*'       | ''              |
		| ''                                   | ''            | ''       | ''          | ''             | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                    | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''          | ''          | ''        | 'Attributes'    |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'               | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                   | 'Receipt'     | '*'      | '5'         | 'Main Company' | 'Purchase order 460*' | 'Store 01'  | 'XS/Blue'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '5'         | 'Main Company' | 'Purchase order 460*' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | 'Purchase order 460*' | 'Store 01'  | '38/Yellow' | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | 'Purchase order 460*' | 'Store 02'  | 'XS/Blue'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | 'Purchase order 460*' | 'Store 02'  | '38/Yellow' | '*'       | '*'             |
		| ''                                   | ''            | ''       | ''          | ''             | ''                    | ''          | ''          | ''        | ''              |
		| 'Register  "Order balance"'          | ''            | ''       | ''          | ''             | ''                    | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''          | ''          | ''        | ''              |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Store'        | 'Order'               | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '5'         | 'Store 01'     | 'Purchase order 460*' | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '5'         | 'Store 02'     | 'Purchase order 460*' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Store 01'     | 'Purchase order 460*' | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Store 02'     | 'Purchase order 460*' | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Store 02'     | 'Purchase order 460*' | '38/Yellow' | '*'         | ''        | ''              |
		И Я закрыл все окна клиентского приложения

Сценарий: _029208 создание Purchase invoice на основании Purchase order (прямая схема поставки, товары)
	И я создаю Purchase invoice на основании Purchase order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 460   |
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
	Тогда я проверяю заполнение табличной части
		И     таблица "ItemList" содержит строки:
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      |'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date'| Purchase order        | Goods receipt | 'Sales order'      |
			| '847,46'     | 'Dress'    | '200,00' | 'XS/Blue'   | '5,000'  |'152,54'     | 'pcs'  | '1 000,00'     | 'Store 01' | '*'            | 'Purchase order 460*' | ''            | 'Sales order 460*' |
			| '1 694,92'   | 'Dress'    | '200,00' | 'XS/Blue'   | '10,000' |'305,08'     | 'pcs'  | '2 000,00'     | 'Store 02' | '*'            | 'Purchase order 460*' | ''            | 'Sales order 461*' |
			| '762,71'     | 'Trousers' | '180,00' | '36/Yellow' | '5,000'  |'137,29'     | 'pcs'  | '900,00'       | 'Store 02' | '*'            | 'Purchase order 460*' | ''            | 'Sales order 461*' |
			| '1 525,42'   | 'Trousers' | '180,00' | '38/Yellow' | '10,000' |'274,58'     | 'pcs'  | '1 800,00'     | 'Store 01' | '*'            | 'Purchase order 460*' | ''            | 'Sales order 460*' |
			| '1 525,42'   | 'Trousers' | '180,00' | '38/Yellow' | '10,000' |'274,58'     | 'pcs'  | '1 800,00'     | 'Store 02' | '*'            | 'Purchase order 460*' | ''            | 'Sales order 461*' |
	И я устанавливаю номер документа 460
		И в поле 'Number' я ввожу текст '460'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '460'
		И я нажимаю на кнопку 'Post and close'
	Тогда я проверяю движения документа
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 460    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Purchase invoice 460*'                 | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Inventory balance"'         | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'      | 'Company'      | 'Item key'              | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '5'             | 'Main Company' | 'XS/Blue'               | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '5'             | 'Main Company' | '36/Yellow'             | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '10'            | 'Main Company' | 'XS/Blue'               | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '10'            | 'Main Company' | '38/Yellow'             | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '10'            | 'Main Company' | '38/Yellow'             | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Purchase turnovers"'        | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'            | ''                      | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                      | ''            | 'Quantity'  | 'Amount'        | 'Net amount'   | 'Company'               | 'Purchase invoice'      | 'Currency'          | 'Item key'           | 'Row key'                 | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                      | '*'           | '5'         | '154,11'        | '130,6'        | 'Main Company'          | 'Purchase invoice 460*' | 'USD'               | '36/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '5'         | '171,23'        | '145,11'       | 'Main Company'          | 'Purchase invoice 460*' | 'USD'               | 'XS/Blue'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '5'         | '900'           | '762,71'       | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | '36/Yellow'          | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '5'         | '900'           | '762,71'       | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | '36/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '5'         | '900'           | '762,71'       | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | '36/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '5'         | '1 000'         | '847,46'       | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | 'XS/Blue'            | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '5'         | '1 000'         | '847,46'       | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | 'XS/Blue'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '5'         | '1 000'         | '847,46'       | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | 'XS/Blue'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '10'        | '308,22'        | '261,2'        | 'Main Company'          | 'Purchase invoice 460*' | 'USD'               | '38/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '10'        | '308,22'        | '261,2'        | 'Main Company'          | 'Purchase invoice 460*' | 'USD'               | '38/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '10'        | '342,47'        | '290,23'       | 'Main Company'          | 'Purchase invoice 460*' | 'USD'               | 'XS/Blue'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '10'        | '1 800'         | '1 525,42'     | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | '38/Yellow'          | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '10'        | '1 800'         | '1 525,42'     | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | '38/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '10'        | '1 800'         | '1 525,42'     | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | '38/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '10'        | '1 800'         | '1 525,42'     | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | '38/Yellow'          | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '10'        | '1 800'         | '1 525,42'     | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | '38/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '10'        | '1 800'         | '1 525,42'     | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | '38/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '10'        | '2 000'         | '1 694,92'     | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | 'XS/Blue'            | '*'                       | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '10'        | '2 000'         | '1 694,92'     | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | 'XS/Blue'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '10'        | '2 000'         | '1 694,92'     | 'Main Company'          | 'Purchase invoice 460*' | 'TRY'               | 'XS/Blue'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'           | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'            | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | 'Attributes'           |
		| ''                                      | ''            | 'Amount'    | 'Manual amount' | 'Net amount'   | 'Document'              | 'Tax'                   | 'Analytics'         | 'Tax rate'           | 'Include to total amount' | 'Row key'                  | 'Currency'             | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'           | '23,51'     | '23,51'         | '130,6'        | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '26,12'     | '26,12'         | '145,11'       | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '47,02'     | '47,02'         | '261,2'        | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '47,02'     | '47,02'         | '261,2'        | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '52,24'     | '52,24'         | '290,23'       | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '137,29'    | '137,29'        | '762,71'       | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'           | '137,29'    | '137,29'        | '762,71'       | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                      | '*'           | '137,29'    | '137,29'        | '762,71'       | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                      | '*'           | '152,54'    | '152,54'        | '847,46'       | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'           | '152,54'    | '152,54'        | '847,46'       | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                      | '*'           | '152,54'    | '152,54'        | '847,46'       | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                      | '*'           | '274,58'    | '274,58'        | '1 525,42'     | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'           | '274,58'    | '274,58'        | '1 525,42'     | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                      | '*'           | '274,58'    | '274,58'        | '1 525,42'     | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                      | '*'           | '274,58'    | '274,58'        | '1 525,42'     | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'           | '274,58'    | '274,58'        | '1 525,42'     | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                      | '*'           | '274,58'    | '274,58'        | '1 525,42'     | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                      | '*'           | '305,08'    | '305,08'        | '1 694,92'     | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'           | '305,08'    | '305,08'        | '1 694,92'     | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                      | '*'           | '305,08'    | '305,08'        | '1 694,92'     | 'Purchase invoice 460*' | 'VAT'                   | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                      | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Goods in transit incoming"' | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'      | 'Store'        | 'Receipt basis'         | 'Item key'              | 'Row key'           | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '5'             | 'Store 02'     | 'Purchase invoice 460*' | '36/Yellow'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '10'            | 'Store 02'     | 'Purchase invoice 460*' | 'XS/Blue'               | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '10'            | 'Store 02'     | 'Purchase invoice 460*' | '38/Yellow'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Accounts statement"'                 | ''                    | ''                    | ''                    | ''               | ''                                               | ''                                               | ''                                     | ''                                     | ''                                     | ''                                               | ''                     | ''                         | ''                     |
		| ''                                               | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                               | ''                                               | 'Dimensions'                           | ''                                     | ''                                     | ''                                               | ''                     | ''                         | ''                     |
		| ''                                               | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                         | 'Transaction AR'                                 | 'Company'                              | 'Partner'                              | 'Legal name'                           | 'Basis document'                                 | 'Currency'             | ''                         | ''                     |
		| ''                                               | 'Receipt'             | '*' | ''                    | '7 500'          | ''                                               | ''                                               | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'                    | 'Purchase invoice 460*' | 'TRY'                  | ''                         | ''                     |
		| ''                                               | ''                    | ''                    | ''                    | ''               | ''                                               | ''                                               | ''                                     | ''                                     | ''                                     | ''                                               | ''                     | ''                         | ''                     |
		| 'Register  "Stock reservation"'         | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'              | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '5'             | 'Store 01'     | 'XS/Blue'               | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '10'            | 'Store 01'     | '38/Yellow'             | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '5'             | 'Store 01'     | 'XS/Blue'               | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '10'            | 'Store 01'     | '38/Yellow'             | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Amount'        | 'Company'      | 'Legal name'            | 'Currency'              | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '7 500'         | 'Main Company' | 'Company Ferron BP'     | 'TRY'                   | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Goods receipt schedule"'    | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                      | ''                      | ''                  | ''                   | 'Attributes'              | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'      | 'Company'      | 'Order'                 | 'Store'                 | 'Item key'          | 'Row key'            | 'Delivery date'           | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '5'             | 'Main Company' | 'Purchase order 460*'   | 'Store 02'              | '36/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '10'            | 'Main Company' | 'Purchase order 460*'   | 'Store 02'              | 'XS/Blue'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '10'            | 'Main Company' | 'Purchase order 460*'   | 'Store 02'              | '38/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '5'             | 'Main Company' | 'Purchase order 460*'   | 'Store 01'              | 'XS/Blue'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '5'             | 'Main Company' | 'Purchase order 460*'   | 'Store 02'              | '36/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '10'            | 'Main Company' | 'Purchase order 460*'   | 'Store 01'              | '38/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '10'            | 'Main Company' | 'Purchase order 460*'   | 'Store 02'              | 'XS/Blue'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '10'            | 'Main Company' | 'Purchase order 460*'   | 'Store 02'              | '38/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'   | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Amount'        | 'Company'      | 'Basis document'        | 'Partner'               | 'Legal name'        | 'Agreement'          | 'Currency'                | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '1 284,25'      | 'Main Company' | 'Purchase invoice 460*' | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'USD'                     | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '7 500'         | 'Main Company' | 'Purchase invoice 460*' | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '7 500'         | 'Main Company' | 'Purchase invoice 460*' | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '7 500'         | 'Main Company' | 'Purchase invoice 460*' | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Order balance"'             | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'      | 'Store'        | 'Order'                 | 'Item key'              | 'Row key'           | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '5'             | 'Store 01'     | 'Purchase order 460*'   | 'XS/Blue'               | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '5'             | 'Store 02'     | 'Purchase order 460*'   | '36/Yellow'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '10'            | 'Store 01'     | 'Purchase order 460*'   | '38/Yellow'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '10'            | 'Store 02'     | 'Purchase order 460*'   | 'XS/Blue'               | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '10'            | 'Store 02'     | 'Purchase order 460*'   | '38/Yellow'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Stock balance"'             | ''            | ''          | ''              | ''             | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                      | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'              | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '5'             | 'Store 01'     | 'XS/Blue'               | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '10'            | 'Store 01'     | '38/Yellow'             | ''                      | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |

	И Я закрыл все окна клиентского приложения

Сценарий: _029209 создание Goods reciept на основании Purchase invoice (прямая схема поставки, товары)
	И я создаю Goods receipt на основании Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 460   |
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	Тогда я проверяю заполнение табличной части
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Sales order'      | 'Store'    | 'Receipt basis'         |
		| 'Dress'    | '10,000'   | 'XS/Blue'   | 'pcs'  | 'Sales order 461*' | 'Store 02' | 'Purchase invoice 460*' |
		| 'Trousers' | '5,000'    | '36/Yellow' | 'pcs'  | 'Sales order 461*' | 'Store 02' | 'Purchase invoice 460*' |
		| 'Trousers' | '10,000'   | '38/Yellow' | 'pcs'  | 'Sales order 461*' | 'Store 02' | 'Purchase invoice 460*' |
	И я устанавливаю номер документа 460
		И в поле 'Number' я ввожу текст '460'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '460'
		И я нажимаю на кнопку 'Post and close'
	Тогда я проверяю движения документа
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 460    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Goods receipt 460*'                    | ''            | ''       | ''          | ''             | ''                      | ''          | ''          | ''        | ''              |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                      | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                      | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'         | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Store 02'     | 'Purchase invoice 460*' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'Purchase invoice 460*' | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'Purchase invoice 460*' | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''          | ''          | ''        | ''              |
		| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''             | ''                      | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'              | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'     | '36/Yellow'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | 'XS/Blue'               | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | '38/Yellow'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Store 02'     | '36/Yellow'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'XS/Blue'               | ''          | ''          | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'     | '38/Yellow'             | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''          | ''          | ''        | ''              |
		| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''             | ''                      | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''          | ''          | ''        | 'Attributes'    |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                 | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Main Company' | 'Purchase invoice 460*' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company' | 'Purchase invoice 460*' | 'Store 02'  | 'XS/Blue'   | '*'       | '*'             |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Main Company' | 'Purchase invoice 460*' | 'Store 02'  | '38/Yellow' | '*'       | '*'             |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                      | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'              | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'     | '36/Yellow'             | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | 'XS/Blue'               | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | '38/Yellow'             | ''          | ''          | ''        | ''              |

Сценарий: _029210 создание Sales invoice на основании Sales orders по которым делалась закупка у поставщика - неордерный склад
	И я создаю Sales invoice по Sales order 460
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 460  |
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
	Тогда я проверяю заполнение табличной части
		И     таблица "ItemList" содержит строки:
		| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales order'      |
		| '520,00' | 'Dress'    | '18%' | 'XS/Blue'   | '5,000'  | '396,61'     | 'pcs'  | '2 203,39'   | '2 600,00'     | 'Store 01' | 'Sales order 460*' |
		| '700,00' | 'Boots'    | '18%' | '36/18SD'   | '1,000'  | '106,78'     | 'pcs'  | '593,22'     | '700,00'       | 'Store 01' | 'Sales order 460*' |
		| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '10,000' | '610,17'     | 'pcs'  | '3 389,83'   | '4 000,00'     | 'Store 01' | 'Sales order 460*' |
		| '200,00' | 'Service'  | '18%' | 'Rent'      | '10,000' | '305,08'     | 'pcs'  | '1 694,92'   | '2 000,00'     | 'Store 01' | 'Sales order 460*' |
	И я устанавливаю номер документа 460
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '460'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '460'
	И я провожу инвойс
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		Тогда открылось окно 'Pickup special offers'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post and close'
	Тогда я проверяю проводки Sales invoice
		И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
		И в таблице "List" я перехожу к строке:
		| Number |
		| 460    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales invoice 460 *'                        | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'        | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | 'Attributes'               | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Amount'        | 'Company'       | 'Basis document'      | 'Partner'      | 'Legal name'          | 'Agreement'           | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation'     | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1 592,47'      | 'Main Company'  | 'Sales invoice 460 *' | 'Lomaniti'     | 'Company Lomaniti'    | 'Basic Agreements, TRY'  | 'USD'                      | 'Reporting currency'       | 'No'                       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '9 300'         | 'Main Company'  | 'Sales invoice 460 *' | 'Lomaniti'     | 'Company Lomaniti'    | 'Basic Agreements, TRY'  | 'TRY'                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '9 300'         | 'Main Company'  | 'Sales invoice 460 *' | 'Lomaniti'     | 'Company Lomaniti'    | 'Basic Agreements, TRY'  | 'TRY'                      | 'Local currency'           | 'No'                       | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '9 300'         | 'Main Company'  | 'Sales invoice 460 *' | 'Lomaniti'     | 'Company Lomaniti'    | 'Basic Agreements, TRY'  | 'TRY'                      | 'TRY'                      | 'No'                       | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Company'       | 'Item key'            | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '1'             | 'Main Company'  | '36/18SD'             | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Main Company'  | 'XS/Blue'             | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'            | 'Main Company'  | '38/Yellow'           | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Item key'            | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '1'             | 'Store 01'      | '36/18SD'             | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 01'      | 'XS/Blue'             | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'            | 'Store 01'      | '38/Yellow'           | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'                | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''              | ''              | 'Dimensions'          | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Amount'    | 'Manual amount' | 'Net amount'    | 'Document'            | 'Tax'          | 'Analytics'           | 'Tax rate'            | 'Include to total amount'  | 'Row key'                  | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '18,28'     | '18,28'         | '101,58'        | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '52,24'     | '52,24'         | '290,23'        | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '67,91'     | '67,91'         | '377,29'        | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '104,48'    | '104,48'        | '580,45'        | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '106,78'    | '106,78'        | '593,22'        | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '106,78'    | '106,78'        | '593,22'        | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '106,78'    | '106,78'        | '593,22'        | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '305,08'    | '305,08'        | '1 694,92'      | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '305,08'    | '305,08'        | '1 694,92'      | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '305,08'    | '305,08'        | '1 694,92'      | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '396,61'    | '396,61'        | '2 203,39'      | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '396,61'    | '396,61'        | '2 203,39'      | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '396,61'    | '396,61'        | '2 203,39'      | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '610,17'    | '610,17'        | '3 389,83'      | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '610,17'    | '610,17'        | '3 389,83'      | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '610,17'    | '610,17'        | '3 389,83'      | 'Sales invoice 460 *' | 'VAT'          | ''                    | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'              | ''                    | ''                    | ''                    | ''               | ''                                            | ''               | ''                                            | ''                                     | ''                         | ''                                            | ''                         | ''                         | ''                     |
		| ''                                            | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                            | ''               | 'Dimensions'                                  | ''                                     | ''                         | ''                                            | ''                         | ''                         | ''                     |
		| ''                                            | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                      | 'Transaction AR' | 'Company'                                     | 'Partner'                              | 'Legal name'               | 'Basis document'                              | 'Currency'                 | ''                         | ''                     |
		| ''                                            | 'Receipt'             | '*' | ''                    | ''               | ''                                            | '9 300'          | 'Main Company'                                | 'Lomaniti'                             | 'Company Lomaniti'         | 'Sales invoice 460*' | 'TRY'                      | ''                         | ''                     |
		| ''                                            | ''                    | ''                    | ''                    | ''               | ''                                            | ''               | ''                                            | ''                                     | ''                         | ''                                            | ''                         | ''                         | ''                     |
		| 'Register  "Sales turnovers"'                | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''              | ''              | ''                    | 'Dimensions'   | ''                    | ''                    | ''                         | ''                         | ''                         | 'Attributes'               | ''                     |
		| ''                                           | ''            | 'Quantity'  | 'Amount'        | 'Net amount'    | 'Offers amount'       | 'Company'      | 'Sales invoice'       | 'Currency'            | 'Item key'                 | 'Row key'                  | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                           | '*'           | '1'         | '119,86'        | '101,58'        | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'USD'                 | '36/18SD'                  | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                           | '*'           | '1'         | '700'           | '593,22'        | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'TRY'                 | '36/18SD'                  | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                           | '*'           | '1'         | '700'           | '593,22'        | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'TRY'                 | '36/18SD'                  | '*'                        | 'Local currency'           | 'No'                       | ''                     |
		| ''                                           | '*'           | '1'         | '700'           | '593,22'        | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'TRY'                 | '36/18SD'                  | '*'                        | 'TRY'                      | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '445,21'        | '377,29'        | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'USD'                 | 'XS/Blue'                  | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '2 600'         | '2 203,39'      | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'TRY'                 | 'XS/Blue'                  | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '2 600'         | '2 203,39'      | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'TRY'                 | 'XS/Blue'                  | '*'                        | 'Local currency'           | 'No'                       | ''                     |
		| ''                                           | '*'           | '5'         | '2 600'         | '2 203,39'      | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'TRY'                 | 'XS/Blue'                  | '*'                        | 'TRY'                      | 'No'                       | ''                     |
		| ''                                           | '*'           | '10'        | '342,47'        | '290,23'        | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'USD'                 | 'Rent'                     | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                           | '*'           | '10'        | '684,93'        | '580,45'        | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'USD'                 | '38/Yellow'                | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                           | '*'           | '10'        | '2 000'         | '1 694,92'      | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'TRY'                 | 'Rent'                     | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                           | '*'           | '10'        | '2 000'         | '1 694,92'      | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'TRY'                 | 'Rent'                     | '*'                        | 'Local currency'           | 'No'                       | ''                     |
		| ''                                           | '*'           | '10'        | '2 000'         | '1 694,92'      | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'TRY'                 | 'Rent'                     | '*'                        | 'TRY'                      | 'No'                       | ''                     |
		| ''                                           | '*'           | '10'        | '4 000'         | '3 389,83'      | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'TRY'                 | '38/Yellow'                | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                           | '*'           | '10'        | '4 000'         | '3 389,83'      | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'TRY'                 | '38/Yellow'                | '*'                        | 'Local currency'           | 'No'                       | ''                     |
		| ''                                           | '*'           | '10'        | '4 000'         | '3 389,83'      | ''                    | 'Main Company' | 'Sales invoice 460 *' | 'TRY'                 | '38/Yellow'                | '*'                        | 'TRY'                      | 'No'                       | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'       | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Amount'        | 'Company'       | 'Legal name'          | 'Currency'     | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '9 300'         | 'Main Company'  | 'Company Lomaniti'    | 'TRY'          | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Revenues turnovers"'             | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | 'Dimensions'    | ''              | ''                    | ''             | ''                    | ''                    | ''                         | 'Attributes'               | ''                         | ''                         | ''                     |
		| ''                                           | ''            | 'Amount'    | 'Company'       | 'Business unit' | 'Revenue type'        | 'Item key'     | 'Currency'            | 'Additional analytic' | 'Currency movement type'   | 'Deferred calculation'     | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '101,58'    | 'Main Company'  | ''              | ''                    | '36/18SD'      | 'USD'                 | ''                    | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '290,23'    | 'Main Company'  | ''              | ''                    | 'Rent'         | 'USD'                 | ''                    | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '377,29'    | 'Main Company'  | ''              | ''                    | 'XS/Blue'      | 'USD'                 | ''                    | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '580,45'    | 'Main Company'  | ''              | ''                    | '38/Yellow'    | 'USD'                 | ''                    | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '593,22'    | 'Main Company'  | ''              | ''                    | '36/18SD'      | 'TRY'                 | ''                    | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '593,22'    | 'Main Company'  | ''              | ''                    | '36/18SD'      | 'TRY'                 | ''                    | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '593,22'    | 'Main Company'  | ''              | ''                    | '36/18SD'      | 'TRY'                 | ''                    | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '1 694,92'  | 'Main Company'  | ''              | ''                    | 'Rent'         | 'TRY'                 | ''                    | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '1 694,92'  | 'Main Company'  | ''              | ''                    | 'Rent'         | 'TRY'                 | ''                    | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '1 694,92'  | 'Main Company'  | ''              | ''                    | 'Rent'         | 'TRY'                 | ''                    | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '2 203,39'  | 'Main Company'  | ''              | ''                    | 'XS/Blue'      | 'TRY'                 | ''                    | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '2 203,39'  | 'Main Company'  | ''              | ''                    | 'XS/Blue'      | 'TRY'                 | ''                    | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '2 203,39'  | 'Main Company'  | ''              | ''                    | 'XS/Blue'      | 'TRY'                 | ''                    | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '3 389,83'  | 'Main Company'  | ''              | ''                    | '38/Yellow'    | 'TRY'                 | ''                    | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '3 389,83'  | 'Main Company'  | ''              | ''                    | '38/Yellow'    | 'TRY'                 | ''                    | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | '*'           | '3 389,83'  | 'Main Company'  | ''              | ''                    | '38/Yellow'    | 'TRY'                 | ''                    | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Order'               | 'Item key'     | 'Row key'             | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '1'             | 'Store 01'      | 'Sales order 460*'    | '36/18SD'      | '*'                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 01'      | 'Sales order 460*'    | 'XS/Blue'      | '*'                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'            | 'Store 01'      | 'Sales order 460*'    | '38/Yellow'    | '*'                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'            | 'Store 01'      | 'Sales order 460*'    | 'Rent'         | '*'                   | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Item key'            | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '1'             | 'Store 01'      | '36/18SD'             | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 01'      | 'XS/Blue'             | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'            | 'Store 01'      | '38/Yellow'           | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''              | ''              | ''                    | ''             | ''                    | ''                    | ''                         | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                    | ''             | ''                    | ''                    | 'Attributes'               | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'      | 'Company'       | 'Order'               | 'Store'        | 'Item key'            | 'Row key'             | 'Delivery date'            | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '1'             | 'Main Company'  | 'Sales order 460*'    | 'Store 01'     | '36/18SD'             | '*'                   | '*'                        | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'             | 'Main Company'  | 'Sales order 460*'    | 'Store 01'     | 'XS/Blue'             | '*'                   | '*'                        | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'            | 'Main Company'  | 'Sales order 460*'    | 'Store 01'     | '38/Yellow'           | '*'                   | '*'                        | ''                         | ''                         | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'            | 'Main Company'  | 'Sales order 460*'    | 'Store 01'     | 'Rent'                | '*'                   | '*'                        | ''                         | ''                         | ''                         | ''                     |
		И Я закрыл все окна клиентского приложения

Сценарий: _029211 создание Sales invoice на основании Sales orders по которым делалась закупка у поставщика - ордерный склад
	И я создаю Sales invoice по Sales order 461
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 461  |
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
	Тогда я проверяю заполнение табличной части
		И     таблица "ItemList" содержит строки:
		| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
		| '520,00' | 'Dress'    | '18%' | 'XS/Blue'   | '10,000' | '793,22'     | 'pcs'  | '4 406,78'   | '5 200,00'     | 'Store 02' |
		| '400,00' | 'Trousers' | '18%' | '36/Yellow' | '5,000'  | '305,08'     | 'pcs'  | '1 694,92'   | '2 000,00'     | 'Store 02' |
		| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '10,000' | '610,17'     | 'pcs'  | '3 389,83'   | '4 000,00'     | 'Store 02' |
		| '300,00' | 'Service'  | '18%' | 'Rent'      | '1,000'  | '45,76'      | 'pcs'  | '254,24'     | '300,00'       | 'Store 02' |
	И я устанавливаю номер документа 461
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '461'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '461'
	И я провожу инвойс
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		Тогда открылось окно 'Pickup special offers'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post and close'
	Тогда я проверяю проводки Sales invoice
		И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
		И в таблице "List" я перехожу к строке:
		| Number |
		| 461    |
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Sales invoice 461*'                         | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Document registrations records'             | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Partner AR transactions"'        | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | 'Attributes'               | ''                         | ''                     |
			| ''                                           | ''            | ''          | 'Amount'        | 'Company'       | 'Basis document'     | 'Partner'      | 'Legal name'         | 'Agreement'             | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation'     | ''                         | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '1 969,18'      | 'Main Company'  | 'Sales invoice 461*' | 'Ferron BP'    | 'Company Ferron BP'  | 'Basic Agreements, TRY' | 'USD'                      | 'Reporting currency'       | 'No'                       | ''                         | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '11 500'        | 'Main Company'  | 'Sales invoice 461*' | 'Ferron BP'    | 'Company Ferron BP'  | 'Basic Agreements, TRY' | 'TRY'                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '11 500'        | 'Main Company'  | 'Sales invoice 461*' | 'Ferron BP'    | 'Company Ferron BP'  | 'Basic Agreements, TRY' | 'TRY'                      | 'Local currency'           | 'No'                       | ''                         | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '11 500'        | 'Main Company'  | 'Sales invoice 461*' | 'Ferron BP'    | 'Company Ferron BP'  | 'Basic Agreements, TRY' | 'TRY'                      | 'TRY'                      | 'No'                       | ''                         | ''                     |
			| ''                                           | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Inventory balance"'              | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | ''            | ''          | 'Quantity'      | 'Company'       | 'Item key'           | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '5'             | 'Main Company'  | '36/Yellow'          | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '10'            | 'Main Company'  | 'XS/Blue'            | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '10'            | 'Main Company'  | '38/Yellow'          | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Goods in transit outgoing"'      | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Shipment basis'     | 'Item key'     | 'Row key'            | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '5'             | 'Store 02'      | 'Sales invoice 461*' | '36/Yellow'    | '*'                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '10'            | 'Store 02'      | 'Sales invoice 461*' | 'XS/Blue'      | '*'                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '10'            | 'Store 02'      | 'Sales invoice 461*' | '38/Yellow'    | '*'                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Order reservation"'              | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Item key'           | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 02'      | '36/Yellow'          | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '10'            | 'Store 02'      | 'XS/Blue'            | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '10'            | 'Store 02'      | '38/Yellow'          | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Taxes turnovers"'                | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Period'      | 'Resources' | ''              | ''              | 'Dimensions'         | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | 'Attributes'           |
			| ''                                           | ''            | 'Amount'    | 'Manual amount' | 'Net amount'    | 'Document'           | 'Tax'          | 'Analytics'          | 'Tax rate'              | 'Include to total amount'  | 'Row key'                  | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
			| ''                                           | '*'           | '7,84'      | '7,84'          | '43,53'         | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
			| ''                                           | '*'           | '45,76'     | '45,76'         | '254,24'        | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
			| ''                                           | '*'           | '45,76'     | '45,76'         | '254,24'        | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
			| ''                                           | '*'           | '45,76'     | '45,76'         | '254,24'        | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
			| ''                                           | '*'           | '52,24'     | '52,24'         | '290,23'        | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
			| ''                                           | '*'           | '104,48'    | '104,48'        | '580,45'        | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
			| ''                                           | '*'           | '135,83'    | '135,83'        | '754,59'        | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'USD'                      | 'Reporting currency'       | 'No'                   |
			| ''                                           | '*'           | '305,08'    | '305,08'        | '1 694,92'      | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
			| ''                                           | '*'           | '305,08'    | '305,08'        | '1 694,92'      | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
			| ''                                           | '*'           | '305,08'    | '305,08'        | '1 694,92'      | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
			| ''                                           | '*'           | '610,17'    | '610,17'        | '3 389,83'      | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
			| ''                                           | '*'           | '610,17'    | '610,17'        | '3 389,83'      | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
			| ''                                           | '*'           | '610,17'    | '610,17'        | '3 389,83'      | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
			| ''                                           | '*'           | '793,22'    | '793,22'        | '4 406,78'      | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
			| ''                                           | '*'           | '793,22'    | '793,22'        | '4 406,78'      | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'Local currency'           | 'No'                   |
			| ''                                           | '*'           | '793,22'    | '793,22'        | '4 406,78'      | 'Sales invoice 461*' | 'VAT'          | ''                   | '18%'                   | 'Yes'                      | '*'                        | 'TRY'                      | 'TRY'                      | 'No'                   |
			| ''                                           | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Accounts statement"'              | ''                    | ''                    | ''                    | ''               | ''                                            | ''               | ''                                            | ''                                     | ''                         | ''                                            | ''                         | ''                         | ''                     |
			| ''                                            | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                            | ''               | 'Dimensions'                                  | ''                                     | ''                         | ''                                            | ''                         | ''                         | ''                     |
			| ''                                            | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                      | 'Transaction AR' | 'Company'                                     | 'Partner'                              | 'Legal name'               | 'Basis document'                              | 'Currency'                 | ''                         | ''                     |
			| ''                                            | 'Receipt'             | '*' | ''                    | ''               | ''                                            | '11 500'         | 'Main Company'                                | 'Ferron BP'                            | 'Company Ferron BP'        | 'Sales invoice 461*' | 'TRY'                      | ''                         | ''                     |
			| ''                                            | ''                    | ''                    | ''                    | ''               | ''                                            | ''               | ''                                            | ''                                     | ''                         | ''                                            | ''                         | ''                         | ''                     |
			| 'Register  "Sales turnovers"'                | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Period'      | 'Resources' | ''              | ''              | ''                   | 'Dimensions'   | ''                   | ''                      | ''                         | ''                         | ''                         | 'Attributes'               | ''                     |
			| ''                                           | ''            | 'Quantity'  | 'Amount'        | 'Net amount'    | 'Offers amount'      | 'Company'      | 'Sales invoice'      | 'Currency'              | 'Item key'                 | 'Row key'                  | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                           | '*'           | '1'         | '51,37'         | '43,53'         | ''                   | 'Main Company' | 'Sales invoice 461*' | 'USD'                   | 'Rent'                     | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                           | '*'           | '1'         | '300'           | '254,24'        | ''                   | 'Main Company' | 'Sales invoice 461*' | 'TRY'                   | 'Rent'                     | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                           | '*'           | '1'         | '300'           | '254,24'        | ''                   | 'Main Company' | 'Sales invoice 461*' | 'TRY'                   | 'Rent'                     | '*'                        | 'Local currency'           | 'No'                       | ''                     |
			| ''                                           | '*'           | '1'         | '300'           | '254,24'        | ''                   | 'Main Company' | 'Sales invoice 461*' | 'TRY'                   | 'Rent'                     | '*'                        | 'TRY'                      | 'No'                       | ''                     |
			| ''                                           | '*'           | '5'         | '342,47'        | '290,23'        | ''                   | 'Main Company' | 'Sales invoice 461*' | 'USD'                   | '36/Yellow'                | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                           | '*'           | '5'         | '2 000'         | '1 694,92'      | ''                   | 'Main Company' | 'Sales invoice 461*' | 'TRY'                   | '36/Yellow'                | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                           | '*'           | '5'         | '2 000'         | '1 694,92'      | ''                   | 'Main Company' | 'Sales invoice 461*' | 'TRY'                   | '36/Yellow'                | '*'                        | 'Local currency'           | 'No'                       | ''                     |
			| ''                                           | '*'           | '5'         | '2 000'         | '1 694,92'      | ''                   | 'Main Company' | 'Sales invoice 461*' | 'TRY'                   | '36/Yellow'                | '*'                        | 'TRY'                      | 'No'                       | ''                     |
			| ''                                           | '*'           | '10'        | '684,93'        | '580,45'        | ''                   | 'Main Company' | 'Sales invoice 461*' | 'USD'                   | '38/Yellow'                | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                           | '*'           | '10'        | '890,41'        | '754,59'        | ''                   | 'Main Company' | 'Sales invoice 461*' | 'USD'                   | 'XS/Blue'                  | '*'                        | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                           | '*'           | '10'        | '4 000'         | '3 389,83'      | ''                   | 'Main Company' | 'Sales invoice 461*' | 'TRY'                   | '38/Yellow'                | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                           | '*'           | '10'        | '4 000'         | '3 389,83'      | ''                   | 'Main Company' | 'Sales invoice 461*' | 'TRY'                   | '38/Yellow'                | '*'                        | 'Local currency'           | 'No'                       | ''                     |
			| ''                                           | '*'           | '10'        | '4 000'         | '3 389,83'      | ''                   | 'Main Company' | 'Sales invoice 461*' | 'TRY'                   | '38/Yellow'                | '*'                        | 'TRY'                      | 'No'                       | ''                     |
			| ''                                           | '*'           | '10'        | '5 200'         | '4 406,78'      | ''                   | 'Main Company' | 'Sales invoice 461*' | 'TRY'                   | 'XS/Blue'                  | '*'                        | 'en descriptions is empty' | 'No'                       | ''                     |
			| ''                                           | '*'           | '10'        | '5 200'         | '4 406,78'      | ''                   | 'Main Company' | 'Sales invoice 461*' | 'TRY'                   | 'XS/Blue'                  | '*'                        | 'Local currency'           | 'No'                       | ''                     |
			| ''                                           | '*'           | '10'        | '5 200'         | '4 406,78'      | ''                   | 'Main Company' | 'Sales invoice 461*' | 'TRY'                   | 'XS/Blue'                  | '*'                        | 'TRY'                      | 'No'                       | ''                     |
			| ''                                           | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'       | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | ''            | ''          | 'Amount'        | 'Company'       | 'Legal name'         | 'Currency'     | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '11 500'        | 'Main Company'  | 'Company Ferron BP'  | 'TRY'          | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Revenues turnovers"'             | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Period'      | 'Resources' | 'Dimensions'    | ''              | ''                   | ''             | ''                   | ''                      | ''                         | 'Attributes'               | ''                         | ''                         | ''                     |
			| ''                                           | ''            | 'Amount'    | 'Company'       | 'Business unit' | 'Revenue type'       | 'Item key'     | 'Currency'           | 'Additional analytic'   | 'Currency movement type'   | 'Deferred calculation'     | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '43,53'     | 'Main Company'  | ''              | ''                   | 'Rent'         | 'USD'                | ''                      | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '254,24'    | 'Main Company'  | ''              | ''                   | 'Rent'         | 'TRY'                | ''                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '254,24'    | 'Main Company'  | ''              | ''                   | 'Rent'         | 'TRY'                | ''                      | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '254,24'    | 'Main Company'  | ''              | ''                   | 'Rent'         | 'TRY'                | ''                      | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '290,23'    | 'Main Company'  | ''              | ''                   | '36/Yellow'    | 'USD'                | ''                      | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '580,45'    | 'Main Company'  | ''              | ''                   | '38/Yellow'    | 'USD'                | ''                      | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '754,59'    | 'Main Company'  | ''              | ''                   | 'XS/Blue'      | 'USD'                | ''                      | 'Reporting currency'       | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '1 694,92'  | 'Main Company'  | ''              | ''                   | '36/Yellow'    | 'TRY'                | ''                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '1 694,92'  | 'Main Company'  | ''              | ''                   | '36/Yellow'    | 'TRY'                | ''                      | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '1 694,92'  | 'Main Company'  | ''              | ''                   | '36/Yellow'    | 'TRY'                | ''                      | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '3 389,83'  | 'Main Company'  | ''              | ''                   | '38/Yellow'    | 'TRY'                | ''                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '3 389,83'  | 'Main Company'  | ''              | ''                   | '38/Yellow'    | 'TRY'                | ''                      | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '3 389,83'  | 'Main Company'  | ''              | ''                   | '38/Yellow'    | 'TRY'                | ''                      | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '4 406,78'  | 'Main Company'  | ''              | ''                   | 'XS/Blue'      | 'TRY'                | ''                      | 'en descriptions is empty' | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '4 406,78'  | 'Main Company'  | ''              | ''                   | 'XS/Blue'      | 'TRY'                | ''                      | 'Local currency'           | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | '*'           | '4 406,78'  | 'Main Company'  | ''              | ''                   | 'XS/Blue'      | 'TRY'                | ''                      | 'TRY'                      | 'No'                       | ''                         | ''                         | ''                     |
			| ''                                           | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Order balance"'                  | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | ''            | ''          | 'Quantity'      | 'Store'         | 'Order'              | 'Item key'     | 'Row key'            | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '1'             | 'Store 02'      | 'Sales order 461*'   | 'Rent'         | '*'                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '5'             | 'Store 02'      | 'Sales order 461*'   | '36/Yellow'    | '*'                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '10'            | 'Store 02'      | 'Sales order 461*'   | 'XS/Blue'      | '*'                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '10'            | 'Store 02'      | 'Sales order 461*'   | '38/Yellow'    | '*'                  | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''              | ''              | ''                   | ''             | ''                   | ''                      | ''                         | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                   | ''             | ''                   | ''                      | 'Attributes'               | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | ''            | ''          | 'Quantity'      | 'Company'       | 'Order'              | 'Store'        | 'Item key'           | 'Row key'               | 'Delivery date'            | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '1'             | 'Main Company'  | 'Sales order 461*'   | 'Store 02'     | 'Rent'               | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '5'             | 'Main Company'  | 'Sales order 461*'   | 'Store 02'     | '36/Yellow'          | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '10'            | 'Main Company'  | 'Sales order 461*'   | 'Store 02'     | 'XS/Blue'            | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '10'            | 'Main Company'  | 'Sales order 461*'   | 'Store 02'     | '38/Yellow'          | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '1'             | 'Main Company'  | 'Sales order 461*'   | 'Store 02'     | 'Rent'               | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '5'             | 'Main Company'  | 'Sales order 461*'   | 'Store 02'     | '36/Yellow'          | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '10'            | 'Main Company'  | 'Sales order 461*'   | 'Store 02'     | 'XS/Blue'            | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |
			| ''                                           | 'Expense'     | '*'         | '10'            | 'Main Company'  | 'Sales order 461*'   | 'Store 02'     | '38/Yellow'          | '*'                     | '*'                        | ''                         | ''                         | ''                         | ''                     |
		И Я закрыл все окна клиентского приложения



# To Do выровнять движения и дописать тесты которые ниже

# Схема отгрузки Sales order (№501) - Purchase order- Purchase invoice - Goods reciept - Shipment confirmation - Sales invoice

Сценарий: _029221 схема отгрузки Sales order - Purchase order - Purchase invoice - Goods reciept - Shipment confirmation - Sales invoice
	* Создание Purchase order на основании Sales order №501
		* Выбор нужного Sales order
			И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
			И в таблице "List" я перехожу к строке:
				| Number |
				| 501    |
			И я нажимаю на кнопку с именем 'FormDocumentPurchaseOrderGeneratePurchaseOrder'
		* Заполнение Purchase order
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Company Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron, TRY |
			И в таблице "List" я выбираю текущую строку
			# сообщение по ценам
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			# сообщение по ценам
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'     |
				| 'Trousers' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'  |
				| 'Shirt' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '180,00'
			И в таблице "ItemList" я завершаю редактирование строки
			* Изменение номера документа
				И я перехожу к закладке "Other"
				И я разворачиваю группу "More"
				И в поле 'Number' я ввожу текст '501'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '501'
			И я нажимаю на кнопку 'Post'
	* Создание Purchase invoice на основании Purchase order №501
		И я нажимаю на кнопку 'Purchase invoice'
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '501'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '501'
		И я нажимаю на кнопку 'Post'
	* Создание Goods reciept на основании Purchase invoice №501
		И я нажимаю на кнопку 'Goods receipt'
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '501'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '501'
		И я нажимаю на кнопку 'Post'
	* Создание Shipment confirmation на основании Sales order №501
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 501    |
		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '501'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '501'
		И я нажимаю на кнопку 'Post'
	* Создание Sales invoice на основании Shipment confirmation №501
		И я нажимаю на кнопку 'Sales invoice'
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '501'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '501'
		И я нажимаю на кнопку 'Post'
		И Я закрыл все окна клиентского приложения




# Схема отгрузки Sales order (№502) - Purchase order - Purchase invoice - Sales invoice
Сценарий: _029222 cхема отгрузки Sales order - Purchase order - Purchase invoice - Sales invoice
	И Я закрыл все окна клиентского приложения
	* Создание Purchase order на основании Sales order №502
		* Выбор нужного Sales order
			И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
			И в таблице "List" я перехожу к строке:
				| Number |
				| 502    |
			И я нажимаю на кнопку с именем 'FormDocumentPurchaseOrderGeneratePurchaseOrder'
		* Заполнение Purchase order
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Company Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron, TRY |
			И в таблице "List" я выбираю текущую строку
			# сообщение по ценам
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			# сообщение по ценам
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'     |
				| 'Trousers' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'  |
				| 'Shirt' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '180,00'
			И в таблице "ItemList" я завершаю редактирование строки
			* Изменение номера документа
				И я перехожу к закладке "Other"
				И я разворачиваю группу "More"
				И в поле 'Number' я ввожу текст '502'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '502'
			И я нажимаю на кнопку 'Post'
	* Создание Purchase invoice на основании Purchase order №502
		И я нажимаю на кнопку 'Purchase invoice'
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '502'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '502'
		И я нажимаю на кнопку 'Post and close'
	* Создание Sales invoice на основании Sales order №502
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 502    |
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '502'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '502'
		И я нажимаю на кнопку 'Post and close'
	



# Схема отгрузки Sales order (№504)- Purchase invoice - Goods reciept - Shipment confirmation - Sales invoice
Сценарий: _029224 cхема отгрузки Sales order - Purchase invoice - Goods reciept - Shipment confirmation - Sales invoice
	И Я закрыл все окна клиентского приложения
	* Создание Purchase invoice на основании Sales order №504
		* Выбор нужного Sales order
			И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
			И в таблице "List" я перехожу к строке:
				| Number |
				| 504    |
			И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		* Заполнение Purchase invoice
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Company Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron, TRY |
			И в таблице "List" я выбираю текущую строку
			# сообщение по ценам
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			# сообщение по ценам
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'     |
				| 'Trousers' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'  |
				| 'Shirt' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '180,00'
			И в таблице "ItemList" я завершаю редактирование строки
			* Изменение номера документа
				И я перехожу к закладке "Other"
				И я разворачиваю группу "More"
				И в поле 'Number' я ввожу текст '504'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '504'
			И я нажимаю на кнопку 'Post'
	* Создание Goods reciept на основании Purchase invoice №504
		И я нажимаю на кнопку 'Goods receipt'
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '504'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '504'
		И я нажимаю на кнопку 'Post'
	* Создание Shipment confirmation на основании Sales order №504
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 504    |
		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '504'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '504'
		И я нажимаю на кнопку 'Post'
	* Создание Sales invoice на основании Shipment confirmation №504
		И я нажимаю на кнопку 'Sales invoice'
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '504'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '504'
		И я нажимаю на кнопку 'Post'
		И Я закрыл все окна клиентского приложения


# Схема отгрузки Sales order (№505)- Purchase invoice - Sales invoice

Сценарий: _029225 cхема отгрузки Sales order - Purchase invoice - Sales invoice
	И Я закрыл все окна клиентского приложения
	* Создание Purchase invoice на основании Sales order №505
		* Выбор нужного Sales order
			И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
			И в таблице "List" я перехожу к строке:
				| Number |
				| 505    |
			И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		* Заполнение Purchase invoice
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Company Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron, TRY |
			И в таблице "List" я выбираю текущую строку
			# сообщение по ценам
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			# сообщение по ценам
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'     |
				| 'Trousers' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'  |
				| 'Shirt' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '180,00'
			И в таблице "ItemList" я завершаю редактирование строки
			* Изменение номера документа
				И я перехожу к закладке "Other"
				И я разворачиваю группу "More"
				И в поле 'Number' я ввожу текст '505'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '505'
			И я нажимаю на кнопку 'Post'
	* Создание Sales invoice на основании Sales order №502
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И в таблице "List" я перехожу к строке:
			| Number |
			| 505    |
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		* Изменение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '505'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '505'
		И я нажимаю на кнопку 'Post and close'


# Схема отгрузки Sales order (№503) - Purchase order - Purchase invoice - Shipment confirmation - Sales invoice

# Схема отгрузки Sales order - Purchase order - Purchase invoice - Goods reciept - Sales invoice

# Схема отгрузки Sales order - Purchase order - Purchase invoice - Sales invoice - Shipment confirmation


