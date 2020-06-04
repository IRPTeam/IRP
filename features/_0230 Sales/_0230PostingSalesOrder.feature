#language: ru
@tree
@Positive
Функционал: проведение документа sales order по регистрам складского учета

Как Разработчик
Я хочу создать проводки документа Заказ клиента
Для того чтобы фиксировать какой товар заказан клиентом

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _023001 создание документа заказа клиента с неордерного склада
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда заполняю данные о клиенте в заказе (Ferron BP, склад 01)
	И я добавляю товар
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		Когда выбираю в заказе item Trousers
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '4,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
	И я перерасчитываю скидки
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
	И я проверяю добавление склада в табличную часть
		# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-231' с именем 'IRP-231'
		# И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    |
		| 'Dress'    | '550,00' | 'L/Green'   | 'Store 01' |
	И я проверяю статус заказа клиента установленный по умолчанию
		И я перехожу к закладке "Other"
		И     элемент формы с именем "Status" стал равен 'Approved'
	И я устанавливаю Delivery date
		И в поле с именем 'DeliveryDate' я ввожу текущую дату
	И я нажимаю на кнопку 'Post and close'

Сценарий: _023002 проверка движений документа заказ клиента по регистру OrderBalance (плюс)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-189' с именем 'IRP-189'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'       | 'Store'    | 'Order'          | 'Item key' |
	| '5,000'    | 'Sales order 1*' | 'Store 01' | 'Sales order 1*' | 'L/Green'  |
	| '4,000'    | 'Sales order 1*' | 'Store 01' | 'Sales order 1*' | '36/Yellow'   |

Сценарий: _023003 проверка движений документа заказ клиента по регистру StockReservation (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-189' с именем 'IRP-189'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'       | 'Store'    | 'Item key' |
	| '5,000'    | 'Sales order 1*' | 'Store 01' | 'L/Green'  |
	| '4,000'    | 'Sales order 1*' | 'Store 01' | '36/Yellow'   |

Сценарий: _023004 проверка движений документа заказ клиента по регистру OrderReservation (плюс)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-189' с именем 'IRP-189'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'       | 'Store'    | 'Item key' |
	| '5,000'    | 'Sales order 1*' | 'Store 01' | 'L/Green'  |
	| '4,000'    | 'Sales order 1*' | 'Store 01' | '36/Yellow'   |

Сценарий: _023005 создание документа заказа клиента с ордерного склада
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю данные о клиенте
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Ferron BP'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Basic Agreements, without VAT' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Company Ferron BP'  |
		И в таблице "List" я выбираю текущую строку
	Когда добавляю товар в заказ клиента (Dress и Trousers)
	И я перерасчитываю скидки
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
	И я проверяю статус заказа клиента установленный по умолчанию
		И я перехожу к закладке "Other"
		И     элемент формы с именем "Status" стал равен 'Approved'
	И я нажимаю на кнопку 'Post and close'

Сценарий: _023006 проверка движений документа заказ клиента по регистру OrderBalance (плюс)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-189' с именем 'IRP-189'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Order'          | 'Item key' |
	| '10,000'    | 'Sales order 2*' | 'Store 02' | 'Sales order 2*' | 'L/Green'  |
	| '14,000'    | 'Sales order 2*' | 'Store 02' | 'Sales order 2*' | '36/Yellow'   |

Сценарий: _023007 проверка движений документа заказ клиента по регистру StockReservation (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-189' с именем 'IRP-189'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '10,000'    | 'Sales order 2*' | 'Store 02' | 'L/Green'  |
	| '14,000'    | 'Sales order 2*' | 'Store 02' | '36/Yellow'   |

Сценарий: _023008 проверка движений документа заказ клиента по регистру OrderReservation (плюс)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-189' с именем 'IRP-189'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
	Тогда таблица "List" содержит строки:
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '10,000'    | 'Sales order 2*' | 'Store 02' | 'L/Green'  |
	| '14,000'    | 'Sales order 2*' | 'Store 02' | '36/Yellow'   |


Сценарий: _023014 проверка движений документа Sales order по статусам + проверка истории статусов
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' | 'Partner'   |
		| '1'      | 'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	И я меняю статус заказа клиента на Wait (не делает проводок)
		И я нажимаю на гиперссылку "Decoration group title collapsed picture"
		И из выпадающего списка "Status" я выбираю точное значение 'Wait'
	И я нажимаю на кнопку 'Post and close'
	И я проверяю отсутвие движений ранее проведенного заказа клиента
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" не содержит строки:
			| 'Recorder'       | 'Order'          |
			| 'Sales order 1*' |'Sales order 1*'  |
			| 'Sales order 1*' |'Sales order 1*' |
		И я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" не содержит строки:
			| 'Recorder'       |
			| 'Sales order 1*' |
			| 'Sales order 1*' |
		И я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
		Тогда таблица "List" не содержит строки:
			| 'Recorder'       |
			| 'Sales order 1*' |
			| 'Sales order 1*' |
		И Я закрываю текущее окно
	И я открываю ранее созданный заказ
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner'   |
			| '1'      | 'Ferron BP' |
		И в таблице "List" я выбираю текущую строку
	И я меняю статус заказа клиента на Approved (не делает проводок)
		И я нажимаю на гиперссылку "Decoration group title collapsed picture"
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку 'Post'
	И я проверяю историю по статусам
		И я нажимаю на гиперссылку "History"
		Тогда таблица "List" содержит строки:
			| 'Object'         | 'Status'   |
			| 'Sales order 1*' | 'Wait'     |
			| 'Sales order 1*' | 'Approved' |
		И я закрываю текущее окно
		И я нажимаю на кнопку 'Post and close'
	И я проверяю движения документа
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Recorder'       | 'Order'          |
			| 'Sales order 1*' |'Sales order 1*'  |
			| 'Sales order 1*' |'Sales order 1*' |
		И я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" содержит строки:
			| 'Recorder'       |
			| 'Sales order 1*' |
			| 'Sales order 1*' |
		И я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderReservation'
		Тогда таблица "List" содержит строки:
			| 'Recorder'       |
			| 'Sales order 1*' |
			| 'Sales order 1*' |
		И Я закрываю текущее окно





Сценарий: _023023 проверка подключения к документу Sales Order Отчета по движениям
	И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
	И я проверяю вывод отчета по выбранному документу из списка
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales order 1*'                             | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'       | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Store 01'     | '36/Yellow'      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | 'L/Green'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'       | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'         | 'Store 01'     | '36/Yellow'      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'         | 'Store 01'     | 'L/Green'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'    | 'Currency'  | 'Item key'  | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '4'         | '273,97'    | 'Main Company' | 'Sales order 1*' | 'USD'       | '36/Yellow' | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | '36/Yellow' | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | '36/Yellow' | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | '36/Yellow' | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '5'         | '470,89'    | 'Main Company' | 'Sales order 1*' | 'USD'       | 'L/Green'   | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | 'L/Green'   | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | 'L/Green'   | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | 'L/Green'   | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'          | 'Item key'  | 'Row key'   | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Store 01'     | 'Sales order 1*' | '36/Yellow' | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | 'Sales order 1*' | 'L/Green'   | '*'         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'          | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Main Company' | 'Sales order 1*' | 'Store 01'  | '36/Yellow' | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | 'Sales order 1*' | 'Store 01'  | 'L/Green'   | '*'       | '*'                        | ''                     |
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
	И я проверяю вывод отчета по выбранному документу
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '1'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем "FormReportDocumentRegistrationsReportRegistrationsReport"
	И я проверяю формирование отчета
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales order 1*'                             | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'       | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Store 01'     | '36/Yellow'      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | 'L/Green'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'       | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'         | 'Store 01'     | '36/Yellow'      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'         | 'Store 01'     | 'L/Green'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'    | 'Currency'  | 'Item key'  | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '4'         | '273,97'    | 'Main Company' | 'Sales order 1*' | 'USD'       | '36/Yellow' | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | '36/Yellow' | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | '36/Yellow' | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | '36/Yellow' | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '5'         | '470,89'    | 'Main Company' | 'Sales order 1*' | 'USD'       | 'L/Green'   | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | 'L/Green'   | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | 'L/Green'   | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | 'Sales order 1*' | 'TRY'       | 'L/Green'   | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'          | 'Item key'  | 'Row key'   | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Store 01'     | 'Sales order 1*' | '36/Yellow' | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | 'Sales order 1*' | 'L/Green'   | '*'         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'          | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Main Company' | 'Sales order 1*' | 'Store 01'  | '36/Yellow' | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | 'Sales order 1*' | 'Store 01'  | 'L/Green'   | '*'       | '*'                        | ''                     |
	И я закрыл все окна клиентского приложения